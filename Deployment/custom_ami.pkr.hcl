source "amazon-ebs" "ubuntu-ami" {
    access_key = "${var.AWS_SECRET_KEY}"
    secret_key = "${var.AWS_ACCESS_KEY}"
    region = "eu-west-3"
    ami_name = "ELK_image - ${uuidv4()}"
    instance_type = "t2.micro"
    source_ami = "ami-052f10f1c45aa2155"
    communicator = "ssh"
    ssh_username = "${var.INSTANCE_USERNAME}"
}
build {
    name = "ELK_build"
    sources = ["source.amazon-ebs.ubuntu-ami"]

    provisioner "file" {
        source = "elasticsearch.yml"
        destination = "/tmp/elasticsearch.yml"
        only = ["amazon-ebs.ubuntu-ami"]
    }
    
    provisioner "file" {
        source = "kibana.yml"
        destination = "/tmp/kibana.yml"
        only = ["amazon-ebs.ubuntu-ami"]
    }

    provisioner "file" {
        source = "apache-01.conf"
        destination = "/tmp/apache-01.conf"
        only = ["amazon-ebs.ubuntu-ami"]
    }
    provisioner "file" {
        source = "installELK.sh"
        destination = "/tmp/installELK.sh"
        only = ["amazon-ebs.ubuntu-ami"]
    }

    provisioner "shell" {
        execute_command = "sudo -S env {{.Vars}} {{.Path}}"
        script = "installELK.sh"
    }
    
}