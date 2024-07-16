output "ec2_public_ip" {
  value = aws_instance.webserver-ec2.public_ip
}
