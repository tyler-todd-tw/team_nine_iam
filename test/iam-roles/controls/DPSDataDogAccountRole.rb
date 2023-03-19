title "DataDog Role"

describe aws_iam_role(role_name: 'datadogaccountrole') do
  it { should exist }
end
