
# Create an IAM profile with default configuration
module "iam-1" {
  source = "sgc-main/ec2-iam/aws"

  server_prefix        = var.server_prefix
  tags                 = var.tags
}


# Create an IAM profile with default configuration and SSM CLI access
module "iam-2" {
  source = "sgc-main/ec2-iam/aws"

  server_prefix        = var.server_prefix
  tags                 = var.tags
  attach_ssm_policies  = true
}

# Create an IAM profile with default configuration, SSM CLI access and Directory Service join permissions for Windows instances
module "iam-3" {
  source = "sgc-main/ec2-iam/aws"

  server_prefix        = var.server_prefix
  tags                 = var.tags
  attach_ds_policy     = true
}


# Create an IAM profile with default configuration and full access to a list of S3 buckets
module "iam-4" {
  source = "sgc-main/ec2-iam/aws"

  server_prefix        = var.server_prefix
  tags                 = var.tags
  s3_readwrite         = true

  bucket_list = [
      "test1",
      "test2"
    ]
}

# Create an IAM profile with default configuration in a China Region
module "iam-5" {
  source = "sgc-main/ec2-iam/aws"

  server_prefix        = var.server_prefix
  tags                 = var.tags
  china_deployment     = true
}

# Create an IAM profile with default configuration and attach external IAM policies
module "iam-6" {
  source = "sgc-main/ec2-iam/aws"

  server_prefix        = var.server_prefix
  tags                 = var.tags
  external_policy_arns = [
    "arn:aws:iam::aws:policy/external-policy-1",
    "arn:aws:iam::aws:policy/external-policy-2"
  ]
}
