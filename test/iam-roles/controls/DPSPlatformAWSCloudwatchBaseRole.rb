title "DPSPlatformAWSCloudwatchBaseRole"

describe aws_iam_role(role_name: 'DPSPlatformAWSCloudwatchBaseRole') do
  it { should exist }
end

describe aws_iam_policy(policy_name: 'DPSPlatformAWSCloudwatchBaseRolePolicy') do
  it { should exist }
  its ('attached_roles') { should include 'DPSPlatformAWSCloudwatchBaseRole' }
end
