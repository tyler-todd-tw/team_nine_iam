title "ReadOnly Role"

describe aws_iam_role(role_name: 'DPSPlatformEksBaseRole') do
  it { should exist }
end

describe aws_iam_policy(policy_name: 'DPSPlatformEksBaseRolePolicy') do
  it { should exist }
  its ('attached_roles') { should include 'DPSPlatformEksBaseRole' }
end
