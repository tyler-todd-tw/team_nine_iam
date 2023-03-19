title "ReadOnly Role"

describe aws_iam_role(role_name: 'DPSReadOnlyRole') do
  it { should exist }
end

describe aws_iam_policy(policy_name: 'ReadOnlyAccess') do
  it { should exist }
  its ('attached_roles') { should include 'DPSReadOnlyRole' }
end
