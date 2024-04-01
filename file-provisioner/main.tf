provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "ec2_example" {
  ami                    = "ami-0c101f26f147fa7fd"
  instance_type          = "t2.micro"
  key_name               = "key_for_demo1"
  vpc_security_group_ids = [aws_security_group.main.id]

  provisioner "file" {
    source = "/home/kali/Desktop/file-provisioner/test-file.txt"
    destination = "/home/ubuntu/test-file.txt"
  }

  connection {
    type = "ssh"
    host = self.public_ip
    user = "ubuntu"
    private_key = file("/home/kali/Desktop/file-provisioner/key_for_demo1")
    timeout = "4m"
  }
}



resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]

  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    }
  ]
}

resource "aws_key_pair" "deployer" {
  key_name   = "key_for_demo1"
  public_key = file("/home/kali/Desktop/file-provisioner/key_for_demo1.pub")
}
