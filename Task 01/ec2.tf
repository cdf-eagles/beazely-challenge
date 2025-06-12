# Create Web Servers (var.instance_list instances per var.azs availability zones)
resource "aws_instance" "webserver" {
  for_each = toset(var.instance_index)

  ami                    = var.ami_default
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.default_instance_sg.id]
  subnet_id              = "${aws_subnet.web_subnets[each.value].id}"
  user_data              = file("user_data.sh")

  tags = merge(
    var.default_tags,
    {
      Name = "${var.instance_name}${var.instance_list[each.value]}"
    },
  )
}
