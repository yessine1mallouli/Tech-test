#AutoScaling Launch Configuration
resource "aws_launch_configuration" "levelup-launchconfig" {
  name_prefix     = "levelup-launchconfig"
  image_id        = lookup(var.AMIS, var.AWS_REGION)
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.levelup_key.key_name
  security_groups = [aws_security_group.levelup-instance.id]
  lifecycle {
    create_before_destroy = true
  }

  provisioner "file" {
      source = "elasticsearch.yml"
      destination = "/tmp/elasticsearch.yml"
  }

  provisioner "file" {
      source = "kibana.yml"
      destination = "/tmp/kibana.yml"
  }

  provisioner "file" {
      source = "apache-01.conf"
      destination = "/tmp/apache-01.conf"
  }

    provisioner "file" {
      source = "installELK.sh"
      destination = "/tmp/installELK.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x    /tmp/installELK.sh",
      "sudo sed -i -e 's/\r$//' /tmp/installELK.sh",  # Remove the spurious CR characters.
      "sudo /tmp/installELK.sh",
    ]
  }

  connection {
    #host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }
}

#Generate Key
resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

#Autoscaling Group
resource "aws_autoscaling_group" "levelup-autoscaling" {
  name                      = "levelup-autoscaling"
  vpc_zone_identifier       = [module.myvpc.public_subnet_1_id, module.myvpc.public_subnet_2_id]
  launch_configuration      = aws_launch_configuration.levelup-launchconfig.name
  min_size                  = 2
  max_size                  = 2
  health_check_grace_period = 200
  health_check_type         = "ELB"
  load_balancers            = [aws_elb.levelup-elb.name]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "LevelUp Custom EC2 instance via LB"
    propagate_at_launch = true
  }
}

output "ELB" {
  value = aws_elb.levelup-elb.dns_name
}