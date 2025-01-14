output "iam_instance_profile_id" {
  description = "The instance profile's ID."
  value       = aws_iam_instance_profile.profile.id
}

output "iam_instance_profile_arn" {
  description = "The ARN assigned by AWS to the instance profile."
  value       = aws_iam_instance_profile.profile.arn
}

output "iam_instance_profile_create_date" {
  description = "The creation timestamp of the instance profile."
  value       = aws_iam_instance_profile.profile.create_date
}

output "iam_instance_profile_name" {
  description = "The instance profile's name"
  value       = aws_iam_instance_profile.profile.name
}

output "iam_instance_profile_path" {
  description = "The path of the instance profile in IAM."
  value       = aws_iam_instance_profile.profile.path
}

output "iam_instance_profile_role" {
  description = "The role assigned to the instance profile."
  value       = aws_iam_instance_profile.profile.role
}

output "iam_instance_profile_unique_id" {
  description = "The unique ID assigned by AWS."
  value       = aws_iam_instance_profile.profile.unique_id
}

##

output "iam_policy_id" {
  description = "The policy's ID."
  value       = aws_iam_policy.policy.id
}

output "iam_policy_arn" {
  description = "The ARN assigned by AWS to this policy."
  value       = aws_iam_policy.policy.arn
}

output "iam_policy_name" {
  description = "The name of the policy."
  value       = aws_iam_policy.policy.name
}

output "iam_policy_path" {
  description = "The path of the policy in IAM."
  value       = aws_iam_policy.policy.path
}

output "iam_policy_policy" {
  description = "The policy document."
  value       = aws_iam_policy.policy.policy
}

output "iam_policy_id_bucket_policy" {
  description = "The policy's ID."
  value       = try(aws_iam_policy.bucket_policy["bucket_policy"].id, "")
}

output "iam_policy_arn_bucket_policy" {
  description = "The ARN assigned by AWS to this policy."
  value       = try(aws_iam_policy.bucket_policy["bucket_policy"].arn, "")
}

output "iam_policy_name_bucket_policy" {
  description = "The name of the policy."
  value       = try(aws_iam_policy.bucket_policy["bucket_policy"].name, "")
}

output "iam_policy_path_bucket_policy" {
  description = "The path of the policy in IAM."
  value       = try(aws_iam_policy.bucket_policy["bucket_policy"].path, "")
}

output "iam_policy_policy_bucket_policy" {
  description = "The policy document."
  value       = try(aws_iam_policy.bucket_policy["bucket_policy"].policy, "")
}

##

output "iam_role_id" {
  description = "The name of the role."
  value       = aws_iam_role.role.id
}

output "iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the role."
  value       = aws_iam_role.role.arn
}

output "iam_role_assume_role_policy" {
  description = "The policy that grants an entity permission to assume the role."
  value       = aws_iam_role.role.assume_role_policy
}

output "iam_role_create_date" {
  description = "The creation date of the IAM role."
  value       = aws_iam_role.role.create_date
}

output "iam_role_force_detach_policies" {
  description = "Specifies to force detaching any policies the role has before destroying it. Defaults to false."
  value       = aws_iam_role.role.force_detach_policies
}

output "iam_role_max_session_duration" {
  description = "The maximum session duration (in seconds) that you want to set for the specified role."
  value       = aws_iam_role.role.max_session_duration
}

output "iam_role_name" {
  description = "The name of the role."
  value       = aws_iam_role.role.name
}

output "iam_role_path" {
  description = "The path to the role."
  value       = aws_iam_role.role.path
}

output "iam_role_unique_id" {
  description = "The stable and unique string identifying the role."
  value       = aws_iam_role.role.unique_id
}

##

output "iam_role_policy_attachment_id" {
  description = "The name of the policy attachment."
  value       = aws_iam_role_policy_attachment.policy.id
}

output "iam_role_policy_attachment_role" {
  description = "The role the policy should be applied to."
  value       = aws_iam_role_policy_attachment.policy.role
}

output "iam_role_policy_attachment_policy_arn" {
  description = "The ARN of the policy you want to apply."
  value       = aws_iam_role_policy_attachment.policy.policy_arn
}

output "iam_role_policy_attachment_id_bucket_policy" {
  description = "The name of the policy attachment."
  value       = try(aws_iam_role_policy_attachment.bucket_policy["bucket_policy"].id, "")
}

output "iam_role_policy_attachment_role_bucket_policy" {
  description = "The role the policy should be applied to."
  value       = try(aws_iam_role_policy_attachment.bucket_policy["bucket_policy"].role, "")
}

output "iam_role_policy_attachment_policy_arn_bucket_policy" {
  description = "The ARN of the policy you want to apply."
  value       = try(aws_iam_role_policy_attachment.bucket_policy["bucket_policy"].policy_arn, "")
}

