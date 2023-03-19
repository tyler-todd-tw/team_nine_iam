title "DPSPlatformHostedZonesRole"

describe aws_iam_role(role_name: 'DPSPlatformHostedZonesRole') do
  it { should exist }
end

describe aws_iam_policy(policy_name: 'DPSPlatformHostedZonesRolePolicy') do
  it { should exist }
  its ('attached_roles') { should include 'DPSPlatformHostedZonesRole' }
end
