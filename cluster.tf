// Configuration data for teleport.yaml generation
data "template_file" "node_user_data" {
  template = file("${path.module}/node_user_data.tpl")

  vars = {
    aws_ec2_instance_name                 = "teleport"
    aws_ec2_instance_fqdn                 = "teleport.backbone.parkrunpointsleague.org"
    region                   = var.region
    cluster_name             = var.cluster_name
    email                    = var.email
    domain_name              = var.route53_domain
    dynamo_table_name        = aws_dynamodb_table.teleport.name
    dynamo_events_table_name = aws_dynamodb_table.teleport_events.name
    locks_table_name         = aws_dynamodb_table.teleport_locks.name
    license_path             = var.license_path
    s3_bucket                = var.s3_bucket_name
    use_acm                  = var.use_acm
    use_letsencrypt          = var.use_letsencrypt
  }
}

// Auth, node, proxy (aka Teleport Cluster) on single AWS instance
resource "aws_instance" "cluster" {
  key_name                    = var.key_name
  ami                         = data.aws_ami.base.id
  instance_type               = var.cluster_instance_type
  subnet_id                   = var.vpc_private_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.cluster.id]
  associate_public_ip_address = false # true
  user_data                   = data.template_file.node_user_data.rendered
  iam_instance_profile        = aws_iam_role.cluster.id
  tags = merge(var.default_tags, {
    Name = "${var.environment.resource_name_prefix}-teleport-bastion"
    # Zone        = var.aws_zones[0]
    Visibility  = "private"
    Application = "teleport-bastion"
  })
}

data "template_file" "teleport-bastion-test" {
  vars = {
    aws_ec2_instance_name                 = "teleport"
    aws_ec2_instance_fqdn                 = "teleport.backbone.parkrunpointsleague.org" #(module.global_variables.org_using_subdomains) ? "${var.environment.resource_name_prefix}-teleport-bastion-test.${var.environment.name}.${module.global_variables.org_domain_name}" : "${var.environment.resource_name_prefix}-teleport-bastion-test.${module.global_variables.org_domain_name}"
//    aws_route53_enabled                   = "TRUE"
//    aws_route53_direct_dns_update_enabled = module.global_variables.route53_direct_dns_update_enabled ? "TRUE" : "FALSE"
//    aws_route53_private_hosted_zone_id    = module.dns[0].route53_private_hosted_zone_id
  }
  # Note the $${...} escaping so the above vars are used
  template = <<EOF
#cloud-config
preserve_hostname: false  # Feels wrong setting this to false, but otherwise will preserve the aws internal hostname "ip-99-99-99-99"
hostname: $${aws_ec2_instance_name}
fqdn: $${aws_ec2_instance_fqdn}
manage_etc_hosts: true

output: {all: '| tee -a /var/log/cloud-init-output.log'}
EOF
}