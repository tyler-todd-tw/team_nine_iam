#!/usr/bin/env bash

cat <<EOF > ${1}.tf
module "${1}" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version     = "~> 5.1"
  create_role = true

  role_name                         = "${1}"
  role_requires_mfa                 = false
  custom_role_policy_arns           = [aws_iam_policy.${1}Policy.arn]
  number_of_custom_role_policy_arns = 1

  trusted_role_arns = ["arn:aws:iam::\${var.nonprod_account_id}:root"]
}


resource "aws_iam_policy" "${1}Policy" {
  name = "${1}Policy"
  path = "/"

  policy = jsonencode({
    "Version": "2012-10-17"
    "Statement": [
      {
        "Action": [

        ]
        "Effect": "Allow"
        "Resource": "*"
      },
    ]
  })
}
EOF

cat <<EOF > test/iam-roles/controls/${1}.rb
title "${1}"

describe aws_iam_role(role_name: '${1}') do
  it { should exist }
end

describe aws_iam_policy(policy_name: '${1}Policy') do
  it { should exist }
  its ('attached_roles') { should include '${1}' }
end

EOF

echo 'edit the ${1}.tf policy resource to define permissions for the new role'
