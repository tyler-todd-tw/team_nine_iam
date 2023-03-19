# PlatformEksBase role
#
# Used by: lab-platform-eks-base pipeline
# manages baseline eks cluster provisioning and configuration

module "DPSPlatformEksBaseRole" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version     = "~> 5.1"
  create_role = true

  role_name                         = "DPSPlatformEksBaseRole"
  role_requires_mfa                 = false
  custom_role_policy_arns           = [aws_iam_policy.DPSPlatformEksBaseRolePolicy.arn]
  number_of_custom_role_policy_arns = 1

  trusted_role_arns = ["arn:aws:iam::${var.nonprod_account_id}:root"]
}

# permissions for the IamProfiles role
resource "aws_iam_policy" "DPSPlatformEksBaseRolePolicy" {
  name = "DPSPlatformEksBaseRolePolicy"

  policy = jsonencode({
    "Version": "2012-10-17"
    "Statement": [
      {
        "Action": [
        "route53:AssociateVPCWithHostedZone",
        "route53:ChangeResourceRecordSets",
        "route53:ChangeTagsForResource",
        "route53:GetChange",
        "route53:CreateHealthCheck",
        "route53:CreateHostedZone",
        "route53:CreateKeySigningKey",
        "route53:CreateVPCAssociationAuthorization",
        "route53:DeactivateKeySigningKey",
        "route53:DeleteHealthCheck",
        "route53:DeleteHostedZone",
        "route53:DeleteKeySigningKey",
        "route53:DeleteVPCAssociationAuthorization",
        "route53:DisassociateVPCFromHostedZone",
        "route53:GetHostedZone",
        "route53:GetHostedZoneCount",
        "route53:GetHostedZoneLimit",
        "route53:ListHostedZones",
        "route53:ListHostedZonesByName",
        "route53:ListHostedZonesByVPC",
        "route53:ListResourceRecordSets",
        "route53:ListTagsForResource",
        "route53:ListTagsForResources",
        "route53:ListVPCAssociationAuthorizations",
        "route53:UpdateHostedZoneComment",
        "autoscaling:AttachInstances",
        "autoscaling:CreateAutoScalingGroup",
        "autoscaling:CreateLaunchConfiguration",
        "autoscaling:CreateOrUpdateTags",
        "autoscaling:DeleteAutoScalingGroup",
        "autoscaling:DeleteLaunchConfiguration",
        "autoscaling:DeleteTags",
        "autoscaling:Describe*",
        "autoscaling:DetachInstances",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:UpdateAutoScalingGroup",
        "autoscaling:SuspendProcesses",
        "ec2:*Console*",
        "ec2:Describe*",
        "ec2:*NetworkAclEntry",
        "ec2:*SecurityGroup*",
        "ec2:*KeyPair",
        "ec2:*LaunchTemplate*",
        "ec2:*NetworkInterface*",
        "ec2:*Image*",
        "ec2:*Placement*",
        "ec2:*Snapshot*",
        "ec2:*Tags",
        "ec2:*Volume*",
        "ec2:*InstanceProfile*",
        "ec2:AssignPrivateIpAddresses",
        "ec2:AssociateRouteTable",
        "ec2:CancelConversionTask",
        "ec2:CancelImportTask",
        "ec2:ConfirmProductInstance",
        "ec2:Import*",
        "ec2:ModifyInstance*",
        "ec2:MonitorInstances",
        "ec2:RebootInstances",
        "ec2:ReportInstanceStatus",
        "ec2:ResetInstanceAttribute",
        "ec2:RunInstances",
        "ec2:StartInstances",
        "ec2:StopInstances",
        "ec2:TerminateInstances",
        "ec2:UnassignPrivateIpAddresses",
        "ec2:UnmonitorInstances",
        "ec2-instance-connect:SendSerial*",
        "ec2:ModifyTrafficMirror*",
        "ec2:DeleteTrafficMirror*",
        "elasticloadbalancing:DescribeLoadBalancers",
        "elasticloadbalancing:DescribeTags",
        "elasticloadbalancing:DescribeLoadBalancerAttributes",
        "elasticfilesystem:*Backup*",
        "elasticfilesystem:*FileSystem*",
        "elasticfilesystem:*Mount*",
        "elasticfilesystem:*Tag*",
        "elasticfilesystem:*Untag*",
        "elasticfilesystem:Describe*",
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribeSubnets",
        "eks:*",
        "iam:AddClientIDToOpenIDConnectProvider",
        "iam:AddRoleToInstanceProfile",
        "iam:AttachRolePolicy",
        "iam:CreateInstanceProfile",
        "iam:CreateOpenIDConnectProvider",
        "iam:CreateServiceLinkedRole",
        "iam:CreatePolicy",
        "iam:CreatePolicyVersion",
        "iam:CreateRole",
        "iam:*Addon",
        "iam:DeleteInstanceProfile",
        "iam:DeleteOpenIDConnectProvider",
        "iam:DeletePolicy",
        "iam:DeletePolicyVersion",
        "iam:DeleteRole",
        "iam:DeleteRolePolicy",
        "iam:DeleteServiceLinkedRole",
        "iam:DetachRolePolicy",
        "iam:GetInstanceProfile",
        "iam:GetOpenIDConnectProvider",
        "iam:GetPolicy",
        "iam:GetPolicyVersion",
        "iam:GetRole",
        "iam:GetRolePolicy",
        "iam:List*",
        "iam:PassRole",
        "iam:PutRolePolicy",
        "iam:Remove*",
        "iam:Tag*",
        "iam:Untag*",
        "iam:Update*",
        "logs:CreateLogGroup",
        "logs:DescribeLogGroups",
        "logs:DeleteLogGroup",
        "logs:ListTagsLogGroup",
        "logs:PutRetentionPolicy",
        "logs:TagLogGroup",
        "logs:UntagLogGroup",
        "kms:CreateGrant",
        "kms:CreateKey",
        "kms:DeleteKey",
        "kms:DescribeKey",
        "kms:GetKeyPolicy",
        "kms:GetKeyRotationStatus",
        "kms:ListResourceTags",
        "kms:ScheduleKeyDeletion",
        "kms:EnableKeyRotation",
        "kms:TagResource",
        "kms:CreateAlias",
        "kms:DeleteAlias",
        "kms:ListAliases",
        "ssm:GetParameter"
        ]
        "Effect": "Allow"
        "Resource": "*"
      },
    ]
  })
}
