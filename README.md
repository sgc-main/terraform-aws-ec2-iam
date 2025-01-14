# AWS EC2 IAM Roles Module

Terraform Module that creates and attaches IAM policies and roles to EC2 instances that are created as standalone or part of an AutoScale Group.  
This module creates:  
* A default policy that gives basic control (read/create tags, start/stop/reboot) of the instance that is applied to, over itself and peer instances of same server role in the same project. 
* Allows the attachemnt of SSM Access Policies `var.attach_ssm_policies`, enabling direct CLI access to the instance, relying only on IAM permissions, not requiring network reachability or SSH key to the instance.
* Allows the attachemnt of Directory Service and SSM Access Policies `var.attach_ds_policy`, enabling AWS Directory Service join of Windows EC2 instances.
* Allows the attachemnt of any External Policies `var.external_policy_arns`.
* While specifying a list of S3 bucket names `var.bucket_list`, configures read-only or full permissions to the specified buckets, `var.s3_readwrite = true/false`.
* Allows deployment of IAM resources to China Region accounts setting `var.china_deployment = true`.
* Handling Autoscale configurations:
  * When the IAM policy is added to a Launch Configuration, part of an AutoScale Group, the creation of a custom Tag is needed "`ATS_Prefix`".  
  * The value of this Tag should always be `var.server_prefix`.  
  * This Tag will allow the dynamic naming of the AutoScaled Instances based on our Launch Configuration Module, and further default permissions, included in this module.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.directory_service_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.directory_service_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.external_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_ec2_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Examples

main.tf  
```hcl

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
```  

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| <a name="input_attach_ds_policy"></a> [attach\_ds\_policy](#input\_attach\_ds\_policy) | Create and attach the Directory Service policy | `bool` | `false` |
| <a name="input_attach_ssm_policies"></a> [attach\_ssm\_policies](#input\_attach\_ssm\_policies) | Attach EC2 instance SSM Access Policies | `bool` | `false` |
| <a name="input_bucket_list"></a> [bucket\_list](#input\_bucket\_list) | List of S3 buckets | `list(string)` | `null` |
| <a name="input_china_deployment"></a> [china\_deployment](#input\_china\_deployment) | Switching service endpoints in IAM roles by default ec2.amazonaws.com and ec2.amazonaws.com.cn when true | `bool` | `false` |
| <a name="input_default_environment"></a> [default\_environment](#input\_default\_environment) | Default Environment | `string` | `"dev"` |
| <a name="input_external_policy_arns"></a> [external\_policy\_arns](#input\_external\_policy\_arns) | List of external policy ARNs to attach to the IAM role | `list(string)` | `[]` |
| <a name="input_iam_instance_profile_path"></a> [iam\_instance\_profile\_path](#input\_iam\_instance\_profile\_path) | Path in which to create the profile. | `string` | `"/"` |
| <a name="input_iam_policy_path"></a> [iam\_policy\_path](#input\_iam\_policy\_path) | Path in which to create the policy. | `string` | `"/"` |
| <a name="input_iam_prefix"></a> [iam\_prefix](#input\_iam\_prefix) | Whether to use name\_prefix or fixed name. | `string` | `""` |
| <a name="input_iam_role_force_detach_policies"></a> [iam\_role\_force\_detach\_policies](#input\_iam\_role\_force\_detach\_policies) | Specifies to force detaching any policies the role has before destroying it. | `string` | `"false"` |
| <a name="input_iam_role_max_permissions_boundary"></a> [iam\_role\_max\_permissions\_boundary](#input\_iam\_role\_max\_permissions\_boundary) | The ARN of the policy that is used to set the permissions boundary for the role. | `string` | `""` |
| <a name="input_iam_role_max_session_duration"></a> [iam\_role\_max\_session\_duration](#input\_iam\_role\_max\_session\_duration) | The maximum session duration (in seconds) that you want to set for the specified role. | `number` | `3600` |
| <a name="input_iam_role_path"></a> [iam\_role\_path](#input\_iam\_role\_path) | The path to the role. | `string` | `""` |
| <a name="input_s3_readwrite"></a> [s3\_readwrite](#input\_s3\_readwrite) | Boolean to enable read/vrite, by default false, allowing readonly | `bool` | `false` |
| <a name="input_server_prefix"></a> [server\_prefix](#input\_server\_prefix) | Server name prefix | `string` | `""` |
| <a name="input_ssm_policy_arns"></a> [ssm\_policy\_arns](#input\_ssm\_policy\_arns) | EC2 instance SSM Access Policy ARNs | `list` | <pre>[<br/>  "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",<br/>  "arn:aws:iam::aws:policy/EC2InstanceConnect"<br/>]</pre> |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map` | `{}` |
| <a name="input_use_name_prefix"></a> [use\_name\_prefix](#input\_use\_name\_prefix) | Whether to use name\_prefix or fixed name. | `bool` | `true` |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_instance_profile_arn"></a> [iam\_instance\_profile\_arn](#output\_iam\_instance\_profile\_arn) | The ARN assigned by AWS to the instance profile. |
| <a name="output_iam_instance_profile_create_date"></a> [iam\_instance\_profile\_create\_date](#output\_iam\_instance\_profile\_create\_date) | The creation timestamp of the instance profile. |
| <a name="output_iam_instance_profile_id"></a> [iam\_instance\_profile\_id](#output\_iam\_instance\_profile\_id) | The instance profile's ID. |
| <a name="output_iam_instance_profile_name"></a> [iam\_instance\_profile\_name](#output\_iam\_instance\_profile\_name) | The instance profile's name |
| <a name="output_iam_instance_profile_path"></a> [iam\_instance\_profile\_path](#output\_iam\_instance\_profile\_path) | The path of the instance profile in IAM. |
| <a name="output_iam_instance_profile_role"></a> [iam\_instance\_profile\_role](#output\_iam\_instance\_profile\_role) | The role assigned to the instance profile. |
| <a name="output_iam_instance_profile_unique_id"></a> [iam\_instance\_profile\_unique\_id](#output\_iam\_instance\_profile\_unique\_id) | The unique ID assigned by AWS. |
| <a name="output_iam_policy_arn"></a> [iam\_policy\_arn](#output\_iam\_policy\_arn) | The ARN assigned by AWS to this policy. |
| <a name="output_iam_policy_arn_bucket_policy"></a> [iam\_policy\_arn\_bucket\_policy](#output\_iam\_policy\_arn\_bucket\_policy) | The ARN assigned by AWS to this policy. |
| <a name="output_iam_policy_id"></a> [iam\_policy\_id](#output\_iam\_policy\_id) | The policy's ID. |
| <a name="output_iam_policy_id_bucket_policy"></a> [iam\_policy\_id\_bucket\_policy](#output\_iam\_policy\_id\_bucket\_policy) | The policy's ID. |
| <a name="output_iam_policy_name"></a> [iam\_policy\_name](#output\_iam\_policy\_name) | The name of the policy. |
| <a name="output_iam_policy_name_bucket_policy"></a> [iam\_policy\_name\_bucket\_policy](#output\_iam\_policy\_name\_bucket\_policy) | The name of the policy. |
| <a name="output_iam_policy_path"></a> [iam\_policy\_path](#output\_iam\_policy\_path) | The path of the policy in IAM. |
| <a name="output_iam_policy_path_bucket_policy"></a> [iam\_policy\_path\_bucket\_policy](#output\_iam\_policy\_path\_bucket\_policy) | The path of the policy in IAM. |
| <a name="output_iam_policy_policy"></a> [iam\_policy\_policy](#output\_iam\_policy\_policy) | The policy document. |
| <a name="output_iam_policy_policy_bucket_policy"></a> [iam\_policy\_policy\_bucket\_policy](#output\_iam\_policy\_policy\_bucket\_policy) | The policy document. |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | The Amazon Resource Name (ARN) specifying the role. |
| <a name="output_iam_role_assume_role_policy"></a> [iam\_role\_assume\_role\_policy](#output\_iam\_role\_assume\_role\_policy) | The policy that grants an entity permission to assume the role. |
| <a name="output_iam_role_create_date"></a> [iam\_role\_create\_date](#output\_iam\_role\_create\_date) | The creation date of the IAM role. |
| <a name="output_iam_role_force_detach_policies"></a> [iam\_role\_force\_detach\_policies](#output\_iam\_role\_force\_detach\_policies) | Specifies to force detaching any policies the role has before destroying it. Defaults to false. |
| <a name="output_iam_role_id"></a> [iam\_role\_id](#output\_iam\_role\_id) | The name of the role. |
| <a name="output_iam_role_max_session_duration"></a> [iam\_role\_max\_session\_duration](#output\_iam\_role\_max\_session\_duration) | The maximum session duration (in seconds) that you want to set for the specified role. |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | The name of the role. |
| <a name="output_iam_role_path"></a> [iam\_role\_path](#output\_iam\_role\_path) | The path to the role. |
| <a name="output_iam_role_policy_attachment_id"></a> [iam\_role\_policy\_attachment\_id](#output\_iam\_role\_policy\_attachment\_id) | The name of the policy attachment. |
| <a name="output_iam_role_policy_attachment_id_bucket_policy"></a> [iam\_role\_policy\_attachment\_id\_bucket\_policy](#output\_iam\_role\_policy\_attachment\_id\_bucket\_policy) | The name of the policy attachment. |
| <a name="output_iam_role_policy_attachment_policy_arn"></a> [iam\_role\_policy\_attachment\_policy\_arn](#output\_iam\_role\_policy\_attachment\_policy\_arn) | The ARN of the policy you want to apply. |
| <a name="output_iam_role_policy_attachment_policy_arn_bucket_policy"></a> [iam\_role\_policy\_attachment\_policy\_arn\_bucket\_policy](#output\_iam\_role\_policy\_attachment\_policy\_arn\_bucket\_policy) | The ARN of the policy you want to apply. |
| <a name="output_iam_role_policy_attachment_role"></a> [iam\_role\_policy\_attachment\_role](#output\_iam\_role\_policy\_attachment\_role) | The role the policy should be applied to. |
| <a name="output_iam_role_policy_attachment_role_bucket_policy"></a> [iam\_role\_policy\_attachment\_role\_bucket\_policy](#output\_iam\_role\_policy\_attachment\_role\_bucket\_policy) | The role the policy should be applied to. |
| <a name="output_iam_role_unique_id"></a> [iam\_role\_unique\_id](#output\_iam\_role\_unique\_id) | The stable and unique string identifying the role. |
<!-- END_TF_DOCS -->