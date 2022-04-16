#cloud-config
preserve_hostname: false  # Feels wrong setting this to false, but otherwise will preserve the aws internal hostname "ip-99-99-99-99"
hostname: ${aws_ec2_instance_name}
fqdn: ${aws_ec2_instance_fqdn}
manage_etc_hosts: true

write_files:
  - path: /etc/teleport.d/conf
    permissions: '0700'
    content: |
      TELEPORT_ROLE=auth,node,proxy
      EC2_REGION=${region}
      TELEPORT_AUTH_SERVER_LB=localhost
      TELEPORT_CLUSTER_NAME=${cluster_name}
      TELEPORT_DOMAIN_ADMIN_EMAIL=${email}
      TELEPORT_DOMAIN_NAME=${domain_name}
      TELEPORT_EXTERNAL_HOSTNAME=${domain_name}
      TELEPORT_DYNAMO_TABLE_NAME=${dynamo_table_name}
      TELEPORT_DYNAMO_EVENTS_TABLE_NAME=${dynamo_events_table_name}
      TELEPORT_LICENSE_PATH=${license_path}
      TELEPORT_LOCKS_TABLE_NAME=${locks_table_name}
      TELEPORT_PROXY_SERVER_LB=${domain_name}
      TELEPORT_S3_BUCKET=${s3_bucket}
      USE_LETSENCRYPT=${use_letsencrypt}
      USE_ACM=${use_acm}

output: {all: '| tee -a /var/log/cloud-init-output.log'}
