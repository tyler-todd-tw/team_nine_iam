{
  "create_iam_profiles": false,
  "is_prod_account": true,
  "aws_default_region": "us-east-2",
  "aws_account_role": "DPSIamProfilesRole",
  "aws_account_id": "{{ op://empc-lab/aws-dps-1/aws-account-id }}",

  "aws_region": "us-east-2",
  "assume_role": "DPSIamProfilesRole",
  "account_id": "{{ op://empc-lab/aws-dps-1/aws-account-id }}",
  "prod_account_id": "{{ op://empc-lab/aws-dps-1/aws-account-id }}",
  "nonprod_account_id": "{{ op://empc-lab/aws-dps-2/aws-account-id }}",
  "datadog_api_key": "{{ op://empc-lab/svc-datadog/api-key }}",
  "datadog_app_key": "{{ op://empc-lab/svc-datadog/app-key }}",
  "twdpsio_gpg_public_key_base64": "{{ op://empc-lab/svc-gpg/public-key-base64 }}"
}
