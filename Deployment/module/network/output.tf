output "vpc_id" {
  value = aws_vpc.levelupvpc.id
}
output "public_subnet_1_id" {
  value = aws_subnet.levelupvpc-public-1.id
}
output "public_subnet_2_id" {
  value = aws_subnet.levelupvpc-public-2.id
}

/*
output "sg_22_id" {
  value = ["${aws_security_group.levelup_sg_22.id}"]
}
*/