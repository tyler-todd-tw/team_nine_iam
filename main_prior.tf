# simplified authorization model
#
# a single member group is defined, inclusion enabling the user or
# service account identity to assume any role in both DPS aws accounts
module "DPSTeamMemberGroup" {
  count = var.create_iam_profiles ? 1 : 0
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "= 4.10.1"

  name = "DPSTeamMemberGroup"

  assumable_roles = [
    "arn:aws:iam::${var.nonprod_account_id}:role/*",
    "arn:aws:iam::${var.prod_account_id}:role/*"
  ]
}

# simplified service account is a general purpose svc account
# used for all pipeline orchestration. Not recommended where
# there are multiple teams such as on client engagements
module "DPSSimpleServiceAccount" {
  create_user = var.create_iam_profiles
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "= 4.7.0"

  name                          = "DPSSimpleServiceAccount"
  create_iam_access_key         = true
  create_iam_user_login_profile = false
  pgp_key                       = var.twdpsio_gpg_public_key_base64
  force_destroy                 = true
  password_reset_required       = false
}

resource "aws_iam_user_group_membership" "DPSSimpleServiceAccount" {
  count = var.create_iam_profiles ? 1 : 0
  user = module.DPSSimpleServiceAccount.iam_user_name

  # this is a hack - for some reason, refering to the module outputs does not work for groups
  groups = ["DPSTeamMemberGroup"]
}

output "DPSSimpleServiceAccount_aws_access_key_id" {
  value = var.create_iam_profiles ? module.DPSSimpleServiceAccount.iam_access_key_id : ""
  sensitive   = true
}

# gpg public key encrypted version of DPSSimpleServiceAccount aws-secret-access-key
output "DPSSimpleServiceAccount_encrypted_aws_secret_access_key" {
  value = var.create_iam_profiles ? module.DPSSimpleServiceAccount.iam_access_key_encrypted_secret : ""
  sensitive   = true
}
