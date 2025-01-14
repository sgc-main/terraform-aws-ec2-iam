variable "china_deployment" {
  description = "Switching service endpoints in IAM roles by default ec2.amazonaws.com and ec2.amazonaws.com.cn when true"
  default     = false
}

variable "use_name_prefix" {
  description = "Whether to use name_prefix or fixed name."
  default     = true
}

variable "iam_prefix" {
  description = "Whether to use name_prefix or fixed name."
  default     = ""
}

variable "iam_policy_path" {
  description = "Path in which to create the policy."
  default     = "/"
}

variable "iam_instance_profile_path" {
  description = "Path in which to create the profile."
  default     = "/"
}

variable "iam_role_force_detach_policies" {
  description = "Specifies to force detaching any policies the role has before destroying it."
  default     = "false"
}

variable "iam_role_path" {
  description = "The path to the role."
  default     = ""
}

variable "iam_role_max_session_duration" {
  description = "The maximum session duration (in seconds) that you want to set for the specified role."
  default     = 3600
}

variable "iam_role_max_permissions_boundary" {
  description = "The ARN of the policy that is used to set the permissions boundary for the role."
  default     = ""
}

variable "server_prefix" {
  description = "Server name prefix"
  default     = ""
}

variable "s3_readwrite" {
  description = "Boolean to enable read/vrite, by default false, allowing readonly"
  type        = bool
  default     = false
}

variable "bucket_list" {
  description = "List of S3 buckets"
  type        = list(string)
  default     = null
}

variable "attach_ssm_policies" {
  description = "Attach EC2 instance SSM Access Policies"
  type        = bool
  default     = false
}

variable "ssm_policy_arns" {
  description = "EC2 instance SSM Access Policy ARNs"
  default     = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/EC2InstanceConnect"
    ]
}

variable "attach_ds_policy" {
  description = "Create and attach the Directory Service policy"
  type        = bool
  default     = false
}

variable "external_policy_arns" {
  description = "List of external policy ARNs to attach to the IAM role"
  type        = list(string)
  default     = []
}

variable default_environment {
  description = "Default Environment"
  default     = "dev"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

