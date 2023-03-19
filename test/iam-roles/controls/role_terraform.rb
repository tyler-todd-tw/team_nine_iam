title "Terraform Role"

describe aws_iam_role(role_name: 'DPSTerraformRole') do
  it { should exist }
end

describe aws_iam_policy(policy_name: 'AdministratorAccess') do
  it { should exist }
  its ('attached_roles') { should include 'DPSTerraformRole' }
end
