provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "notesproject" {
  ami           = "ami-04c913012f8977029"
  instance_type = "t2.micro"
  key_name      = "docker.pem"
  

  tags = {
    Name = "notesproject"
  }
}