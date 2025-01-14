
locals {
  iam_prefix             = var.iam_prefix == "" ? var.server_prefix : var.iam_prefix
  assume_role_service    = var.china_deployment ? "ec2.amazonaws.com.cn" : "ec2.amazonaws.com"
  policy_resource_region = var.china_deployment ? "aws-cn" : "aws"
  tags                   = merge(var.tags, { Environment = lookup(var.tags, "Environment", var.default_environment) })

  bucket_arn_list = var.bucket_list != null ? concat(
    formatlist("arn:${local.policy_resource_region}:s3:::%s", var.bucket_list),
    formatlist("arn:${local.policy_resource_region}:s3:::%s/*", var.bucket_list)
    ) : []
  bucket_permissions = var.s3_readwrite ? ["s3:Put*", "s3:Get*", "s3:Delete*", "s3:List*"] : ["s3:Get*", "s3:List*"]
  attach_ds_policy   = var.attach_ds_policy ? ["directory_service_policy"] : []
}

# IAM Policy
resource "aws_iam_policy" "policy" {
  name        = var.use_name_prefix ? null : "${local.iam_prefix}-policy"
  name_prefix = var.use_name_prefix ? "${local.iam_prefix}-policy-" : null
  path        = var.iam_policy_path

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "InstancePolicy0",
        Effect = "Allow",
        Action = [
          "ec2:CreateTags"
        ],
        Resource = "arn:${local.policy_resource_region}:ec2:*:*:instance/*",
        Condition = {
          StringLike = {
            "ec2:ResourceTag/ATS_Prefix" = var.server_prefix
          },
          StringEqualsIgnoreCase = {
            "ec2:ResourceTag/Environment" = local.tags["Environment"]
          }
        }
      },
      {
        Sid = "InstancePolicy1",
        Effect = "Allow",
        Action = [
          "ec2:RebootInstances",
          "ec2:StartInstances",
          "ec2:CreateTags",
          "ec2:StopInstances",
          "ec2:GetConsoleScreenshot"
        ],
        Resource = "arn:${local.policy_resource_region}:ec2:*:*:instance/*",
        Condition = {
          StringLike = {
            "ec2:ResourceTag/Name" = format("%s*", var.server_prefix)
          },
          StringEqualsIgnoreCase = {
            "ec2:ResourceTag/Environment" = local.tags["Environment"]
          }
        }
      },
      {
        Sid = "InstancePolicy2",
        Effect = "Allow",
        Action = [
          "ec2:DescribeTags"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "bucket_policy" {
  for_each = var.bucket_list != null ? tomap({"bucket_policy" = 1}) : {}

  name        = var.use_name_prefix ? null : "${local.iam_prefix}-bucket-policy"
  name_prefix = var.use_name_prefix ? "${local.iam_prefix}-bucket-policy-" : null
  path        = var.iam_policy_path

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "BucketPolicy0",
        Effect = "Allow",
        Action = local.bucket_permissions,
        Resource = local.bucket_arn_list
      }
    ]
  })
}

resource "aws_iam_policy" "directory_service_policy" {
  for_each = toset(local.attach_ds_policy)

  name        = var.use_name_prefix ? null : "${local.iam_prefix}-ds-policy"
  name_prefix = var.use_name_prefix ? "${local.iam_prefix}-ds-policy-" : null
  path        = var.iam_policy_path

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ds:DescribeDirectories",
          "ds:CreateComputer",
          "ds:DeleteComputer"
        ],
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "role" {
  name                  = var.use_name_prefix ? null : "${local.iam_prefix}-role"
  name_prefix           = var.use_name_prefix ? "${local.iam_prefix}-role-" : null
  path                  = var.iam_instance_profile_path
  force_detach_policies = var.iam_role_force_detach_policies
  max_session_duration  = var.iam_role_max_session_duration
  permissions_boundary  = var.iam_role_max_permissions_boundary

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = local.assume_role_service
        }
        Effect = "Allow"
        Sid = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_role_policy_attachment" "ssm_ec2_access" {
  for_each = { for arn in var.ssm_policy_arns : arn => arn if var.attach_ssm_policies || var.attach_ds_policy }

  role       = aws_iam_role.role.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "bucket_policy" {
  for_each = var.bucket_list != null ? tomap({"bucket_policy" = 1}) : {}

  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.bucket_policy["bucket_policy"].arn
}

resource "aws_iam_role_policy_attachment" "directory_service_policy" {
  for_each = toset(local.attach_ds_policy)

  role       = aws_iam_role.your_role_name.name
  policy_arn = aws_iam_policy.directory_service_policy[each.key].arn
}

resource "aws_iam_role_policy_attachment" "external_policy" {
  for_each = { for arn in var.external_policy_arns : arn => arn if length(var.external_policy_arns) > 0 }

  role       = aws_iam_role.role.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "profile" {
  name        = var.use_name_prefix ? null : "${local.iam_prefix}-profile"
  name_prefix = var.use_name_prefix ? "${local.iam_prefix}-profile-" : null
  path        = var.iam_instance_profile_path
  role        = aws_iam_role.role.name
}

