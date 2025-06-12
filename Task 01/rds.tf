# Creating RDS Instance
resource "aws_db_subnet_group" "default" {
  name       = "primary"
  subnet_ids = var.db_subnet_cidrs

  tags = merge(
    var.default_tags,
    {
      Name = "${var.vpc_name} DB Subnet Group"
    },
  )
}

resource "aws_db_instance" "default" {
  allocated_storage          = 10 # 10GB storage
  db_subnet_group_name       = aws_db_subnet_group.default.id
  engine                     = "mysql"
  engine_version             = "8.4"
  auto_minor_version_upgrade = true
  instance_class             = "db.t3.micro"
  multi_az                   = true
  db_name                    = "task_one_db"
  username                   = "testuser"
  password                   = "testpassword123!" # should use manage_master_user_password for production environments
  skip_final_snapshot        = true
  vpc_security_group_ids     = [aws_security_group.default_db_sg.id]
  maintenance_window         = "Mon:00:00-Mon:03:00"
  deletion_protection        = false # set this to true for production

  tags = merge(
    var.default_tags,
    {
      Name = "${var.vpc_name} Default RDS Database"
    },
  )
}
