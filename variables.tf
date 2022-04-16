// Region is AWS region, the region should support EFS
variable "region" {
  type = string
}
variable "environment" {
  description = "Environment information e.g. account IDs, public/private subnet cidrs"
  type = object({
    name                         = string # Environment Account IDs are used for giving permissions to those Accounts for resources such as AMIs
    account_id                   = string
    resource_name_prefix         = string # For some environments  (e.g. Core, Customer/production) want to protect against accidental deletion of resources
    resource_deletion_protection = bool
    default_tags                 = map(string)
  })
  default = {
    name                         = ""
    account_id                   = ""
    resource_name_prefix         = ""
    resource_deletion_protection = true
    default_tags                 = {}
  }
}
variable "vpc_id" {
  description = "The VPC ID"
  type        = string
  default     = ""
  validation {
    condition     = length(var.vpc_id) > 0
    error_message = "Error : the variable 'vpc_id' must be non-empty."
  }
}
variable "vpc_private_subnet_ids" {
  description = "The VPC private subnet IDs list"
  type        = list(string)
  default     = []
}
variable "vpc_private_subnet_cidrs" {
  description = "The VPC private subnet CIDRs list"
  type        = list(string)
  default     = []
}
variable "route53_hosted_zone_id" {
  description = "Route53 Hosted Zone ID (if in use)."
  default     = ""
  type        = string
}
// Teleport cluster name to set up
variable "cluster_name" {
  type = string
}

// Path to Teleport Enterprise license file
variable "license_path" {
  type    = string
  default = ""
}

// AMI name to use
variable "ami_name" {
  type = string
}

// DNS and letsencrypt integration variables
// Zone name to host DNS record, e.g. example.com
variable "route53_zone" {
  type = string
}

// Domain name to use for Teleport proxy,
// e.g. proxy.example.com
variable "route53_domain" {
  type = string
}

// S3 Bucket to create for encrypted letsencrypt certificates
variable "s3_bucket_name" {
  type = string
}

// Email for LetsEncrypt domain registration
variable "email" {
  type = string
}


// SSH key name to provision instances with
variable "key_name" {
  type = string
}

// Whether to use Amazon-issued certificates via ACM or not
// This must be set to true for any use of ACM whatsoever, regardless of whether Terraform generates/approves the cert
variable "use_letsencrypt" {
  type = string
}

// Whether to use Amazon-issued certificates via ACM or not
// This must be set to true for any use of ACM whatsoever, regardless of whether Terraform generates/approves the cert
variable "use_acm" {
  type = string
}

variable "kms_alias_name" {
  default = "alias/aws/ssm"
}

// Instance type for cluster
variable "cluster_instance_type" {
  type    = string
  default = "t3.nano"
}
variable "default_tags" {
  description = "Default tags"
  default     = {}
  type        = map(string)
}
