resource "aws_instance" "web" {
  ami           = "${var.aws_ami}"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.sg.id}"]
  subnet_id = "${aws_subnet.main.id}"
  key_name        = "${var.key_name}"

  tags {
    Name = "${var.name}"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file("~/.ssh/id_rsa")}"
    password = "${var.key_name}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y ",
      "sudo yum install -y docker",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      "sudo yum -y install git",
      "sudo git clone https://github.com/zeineldin/docker-nginx-sandbox.git",
      "cd docker-nginx-sandbox",
      "sudo docker build -t testnginx  . ",
      "sudo docker run -d -p 80:80 testnginx",
 
    ]

 }

}
