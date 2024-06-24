provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "notesproject" {
  ami           = "ami-003c463c8207b4dfa"
  instance_type = "t2.micro"
  key_name      = "docker.pem"
  

  tags = {
    Name = "jenkins-server"
  }
}