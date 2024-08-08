variable "ami" {
  default = "ami-07652eda1fbad7432" //Ubuntu 22.04
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "frankfurt_key-pair"
}

variable "subnet_id_1a" {
  default = "subnet-08e2fbbffde3f7977"
}

# variable "subnet_id_1b" {
#   default = "subnet-0fe35fb0c465670cd"
# }

variable "iam_instance_profile" {
  default = "SessionManagerRole"
}

variable "sonar_instance_type" {
  default = "t2.medium"
}
