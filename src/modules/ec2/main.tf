data "aws_key_pair" "key" {
  key_name           = var.key_pair
  include_public_key = true

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
    #user_data = file(var.user_data_file)
    user_data = <<-EOF
                #!/bin/bash

                # Update and upgrade packages
                sudo apt-get update -y
                sudo apt-get upgrade -y

                # Install Nginx
                sudo apt-get install -y nginx
                sudo systemctl start nginx
                sudo systemctl enable nginx

                # Install SSM Agent
                sudo snap install amazon-ssm-agent --classic
                sudo systemctl enable amazon-ssm-agent
                sudo systemctl start amazon-ssm-agent

                # Install CodeDeploy Agent
                sudo apt-get update -y
                sudo apt-get install -y ruby-full wget
                cd /home/ubuntu
                wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
                chmod +x ./install
                sudo ./install auto
                sudo systemctl enable codedeploy-agent
                sudo systemctl start codedeploy-agent

                # Install AWS CLI
                sudo apt-get install -y awscli
                EOF
    key_name = data.aws_key_pair.key.key_name
}


