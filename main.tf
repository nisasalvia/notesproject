provider "aws" {
  region = "ap-southeast-1b"
}

resource "aws_instance" "notesproject" {
  ami           = "ami-003c463c8207b4dfa"
  instance_type = "t2.micro"
  key_name      = "docker.pem"
  vpc_security_group_ids = ["sg-0c185980fd7c310c7"]

  tags = {
    Name = "jenkins-server"
  }
}

output "public_ip" {
  value = aws_instance.notesproject.public_ip
}