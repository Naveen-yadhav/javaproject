# Versions
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Providers
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}


# Resource
resource "aws_instance" "jenkins" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id_1a
  vpc_security_group_ids = ["sg-077fced5d5205d41f"]
  iam_instance_profile   = var.iam_instance_profile
  #user_data              = file("/Users/ck/repos/iac-terraform/iac/web.sh")
  user_data = <<-EOF
  #!/bin/bash
  sudo hostnamectl set-hostname "jenkins.cloudbinary.io"
  echo "`hostname -I | awk '{ print $1 }'` `hostname`" >> /etc/hosts
  sudo apt-get update
  sudo apt-get install git wget unzip curl tree -y
  sudo apt-get -y install git binutils
  sudo apt-get install openjdk-17-jdk -y
  sudo cp -pvr /etc/environment "/etc/environment_$(date +%F_%R)"
  echo "JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/" >> /etc/environment
  source /etc/environment
  sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
  echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
  sudo apt-get update
  sudo apt-get install jenkins -y
  sudo systemctl enable jenkins
  sudo systemctl start jenkins
  EOF

  tags = {
    Name        = "Jenkins"
    Environment = "Dev"
    ProjectName = "Cloud Binary"
    ProjectID   = "2024"
    CreatedBy   = "IaC Terraform"
  }
}

# # Resource
# resource "aws_instance" "efs2" {
#   ami                    = var.ami
#   instance_type          = var.instance_type
#   key_name               = var.key_name
#   subnet_id              = var.subnet_id_1b
#   vpc_security_group_ids = ["sg-077fced5d5205d41f"]
#   iam_instance_profile   = var.iam_instance_profile
#   #user_data              = file("/Users/ck/repos/iac-terraform/iac/web.sh")
#   user_data = <<-EOF
#   #!/bin/bash
#   sudo apt-get update
#   sudo apt-get install apache2 -y 
#   sudo apt-get -y install git binutils
#   cd /opt/
#   git clone https://github.com/aws/efs-utils
#   cd /opt/efs-utils
#   bash /opt/efs-utils/build-deb.sh
#   sudo apt-get -y install ./build/amazon-efs-utils*deb
#   systemctl status rpcbind.service
#   sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-0082ac7fc88014b83.efs.us-east-1.amazonaws.com:/ /var/www/html/
#   echo "Welcome To EFS DEMO -  Iam Server-2 `hostname`" > /var/www/html/index.html
#   EOF

#   tags = {
#     Name        = "efs Instance -2"
#     Environment = "Dev"
#     ProjectName = "Cloud Binary"
#     ProjectID   = "2023"
#     CreatedBy   = "IaC Terraform"
#   }
# }

# Outputs
output "ami" {
  value = aws_instance.jenkins.ami
}
output "public_ip" {
  value = aws_instance.jenkins.public_ip
}
output "private_ip" {
  value = aws_instance.jenkins.private_ip
}

# output "ami_ec2" {
#   value = aws_instance.efs2.ami
# }
# output "public_ip_ec2" {
#   value = aws_instance.efs2.public_ip
# }
# output "private_ip_ec2" {
#   value = aws_instance.efs2.private_ip
# }