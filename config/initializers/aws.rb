Aws.config.update(
  region: 'ap-southeast-2',
  credentials: Aws::Credentials.new(Rails.application.credentials.aws[:access_key_id], Rails.application.credentials.aws[:secret_access_key])
)

s3 = Aws::S3::Resource.new

BUCKET = s3.bucket(Rails.application.credentials.aws[:bucket])