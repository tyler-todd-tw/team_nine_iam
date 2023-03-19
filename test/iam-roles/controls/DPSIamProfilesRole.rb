title "ReadOnly Role"

describe aws_iam_role(role_name: 'DPSIamProfilesRole') do
  it { should exist }
end

describe aws_iam_policy(policy_name: 'DPSIamProfilesRolePolicy') do
  it { should exist }
  its ('attached_roles') { should include 'DPSIamProfilesRole' }
end
