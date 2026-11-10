resource "aws_organizations_policy" "deny_disable_s3_public_access" {
  name        = "DenyDisableS3PublicAccess"
  description = "Prevent disabling S3 Block Public Access controls."
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "DenyDisableS3PublicAccess"
        Effect = "Deny"

        Action = [
          "s3:PutAccountPublicAccessBlock",
          "s3:DeleteAccountPublicAccessBlock",
          "s3:PutBucketPublicAccessBlock",
          "s3:DeleteBucketPublicAccessBlock"
        ]

        Resource = "*"
      }
    ]
  })
}

# must be deployed on each account wanting protection:
resource "aws_s3_account_public_access_block" "organisation" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}