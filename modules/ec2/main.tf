# data "aws_key_pair" "key" {
#   key_name           = var.key_pair
#   include_public_key = true

# }

resource "aws_key_pair" "my_key_pair" {
  key_name   = "challenge"            
  #public_key = file("~/.ssh/id_rsa.pub") 
  public_key = file("C:/Users/walla/.ssh/id_ed25519.pub")
}


resource "aws_instance" "webserver-ec2" {
    ami           = var.ami_id
    instance_type = var.instance_type
    vpc_security_group_ids = [var.security_group_id]
    subnet_id     = var.public_subnet_id
    tags = {
        Name = var.name_ec2
    }
    iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
    user_data = file(var.user_data_file)
    key_name = aws_key_pair.my_key_pair.key_name
}