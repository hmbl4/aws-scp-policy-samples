# CloudTrail protection Service Control Policy

resource "aws_organizations_policy" "cloudtrail_protection" {
  name        = "Prevent-CloudTrail-Disable"
  description = "Stops member accounts from disabling cloudtrail"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "DenyCloudTrailLoggingDisruption"
        Effect = "Deny"

        Action = [
          "cloudtrail:StopLogging",
          "cloudtrail:DeleteTrail"
        ]

        Resource = "*"
      }
    ]
  })
}

# Attach SCP to AWS Organizations OU

resource "aws_organizations_policy_attachment" "cloudtrail_protection" {
  policy_id = aws_organizations_policy.cloudtrail_protection.id
  target_id = var.target_ou_id
}

variable "target_ou_id" {
  description = "AWS Organizations OU ID to apply SCP"
  type        = string
}
