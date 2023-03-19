title "DPSPlatformVPCRole"

describe aws_iam_role(role_name: 'DPSPlatformVPCRole') do
  it { should exist }
end

describe aws_iam_policy(policy_name: 'DPSPlatformVPCRolePolicy') do
  it { should exist }
  its ('attached_roles') { should include 'DPSPlatformVPCRole' }
end
