resource "aws_key_pair" "deployer" {
  key_name_prefix = "deployer-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

data "aws_ami" "wordpress" {
  most_recent = true

  filter {
    name = "name"
    values = ["acid232-wordpress"]
  }

  owners = ["self"]
}

data "aws_subnet" "public" {
  id = "${module.network.mgmt_public_subnet_ids[0]}"
}

resource "aws_instance" "wordpress" {
  ami = "${data.aws_ami.wordpress.id}"
  instance_type = "t2.micro"
  subnet_id = "${data.aws_subnet.public.id}"
  vpc_security_group_ids = ["${aws_security_group.wordpress_ec2.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"

  tags {
    Name = "WordPress"
  }

  provisioner "remote-exec" {
    inline = ["echo Successfully connected"]

    connection {
      user = "${var.ssh_user}"
    }
  }
}

resource "aws_eip" "public" {
  instance = "${aws_instance.wordpress.id}"
  vpc = true
}
