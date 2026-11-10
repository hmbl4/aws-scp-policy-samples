resource "aws_organizations_policy" "iam_mfa_enforcement" {
  name        = "Enforce-MFA"
  description = "MFA must be enabled before any other actions can be taken."
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "DenyAllActionsWithoutMFA"
        Effect = "Deny"

        NotAction = [
          "iam:CreateVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:GetUser",
          "iam:ListMFADevices",
          "iam:ListVirtualMFADevices",
          "iam:ResyncMFADevice",
          "iam:ChangePassword",
          "iam:GetAccountPasswordPolicy",
          "sts:GetSessionToken"
        ]

        Resource = "*"

        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}

resource "aws_organizations_policy_attachment" "iam_mfa_enforcement" {
  policy_id = aws_organizations_policy.iam_mfa_enforcement.id
  target_id = var.target_ou_id
}