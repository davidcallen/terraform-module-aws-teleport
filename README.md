# Terraform module to deploy a Teleport Server 

This is a simple Terraform to provision an all-in-one Teleport cluster (auth, node, proxy) on a single ec2 instance based on Teleport's pre-built AMI.

This was based off Gravitational's aws example [here](https://github.com/gravitational/teleport/tree/master/examples/aws/terraform/starter-cluster).

Note : this module is a work-in-progress.  

Detail
-------
Teleport AMIs are built so you only need to specify environment variables to bring a fully configured instance online. See `data.tpl` or our [documentation](https://gravitational.com/teleport/docs/aws_oss_guide/#single-oss-teleport-amis-manual-gui-setup) to learn more about supported environment variables.

A series of systemd [units](https://github.com/gravitational/teleport/tree/master/assets/aws/files/system) bootstrap the instance, via several bash [scripts](https://github.com/gravitational/teleport/tree/master/assets/aws/files/bin).

While this may not be sufficient for all use cases, it's a great proof-of-concept that you can fork and customize to your liking. Check out our AWS AMI [generation code](https://github.com/gravitational/teleport/tree/master/assets/aws) if you're interested in adapting this to your requirements.

This Terraform example will configure the following AWS resources:

- Teleport all-in-one (auth, node, proxy) single cluster ec2 instance
- DynamoDB tables (cluster state, cluster events, ssl lock)
- S3 bucket (session recording storage)
- Route53 `A` record
- Security Groups and IAM roles
