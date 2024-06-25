provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "notesproject" {
  ami           = "ami-003c463c8207b4dfa"
  instance_type = "t2.micro"
  key_name      = "keynotes"
  associate_public_ip_address = true
  vpc_security_group_ids = ["sg-08006a1c4ebd5a8ff"]

  tags = {
    Name = "notesproject"
  }
}

# output "public_ip" {
#   value = aws_instance.notesproject.public_ip
# }