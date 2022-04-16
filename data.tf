data "aws_ami" "base" {
  most_recent = true
  owners      = [126027368216]

  filter {
    name   = "name"
    values = [var.ami_name]
  }
}

data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
  name = var.region
}

data "aws_availability_zones" "available" {
}

// SSM is picking alias for key to use for encryption in SSM
data "aws_kms_alias" "ssm" {
  name = var.kms_alias_name
}
