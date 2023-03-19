title "DPSPlatformKubecostRole"

describe aws_iam_role(role_name: 'DPSPlatformKubecostRole') do
  it { should exist }
end

describe aws_iam_policy(policy_name: 'DPSPlatformKubecostRolePolicy') do
  it { should exist }
  its ('attached_roles') { should include 'DPSPlatformKubecostRole' }
end

