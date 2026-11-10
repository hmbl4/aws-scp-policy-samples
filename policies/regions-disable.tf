# NB: Services under NotAction must remain accessible because they are global services. 

resource "aws_organizations_policy" "deny_all_outside_sydney" {
  name        = "DenyAllOutsideSydney"
  description = "Deny all activity on services outside of ap-southeast-2 region (Sydney), apart from the services listed under NotAction."
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "DenyAllOutsideSydney"
        Effect = "Deny"

        NotAction = [
          "iam:*",
          "sts:*",
          "cloudfront:*",
          "route53:*",
          "route53domains:*",
          "support:*",
          "trustedadvisor:*",
          "health:*",
          "organizations:*",
          "budgets:*",
          "ce:*",
          "cur:*",
          "pricing:*",
          "waf:*",
          "wafv2:*",
          "shield:*",
          "globalaccelerator:*",
          "networkmanager:*"
        ]

        Resource = "*"

        Condition = {
          StringNotEquals = {
            "aws:RequestedRegion" = [
              "ap-southeast-2"
            ]
          }
        }
      }
    ]
  })
}

resource "aws_organizations_policy_attachment" "deny_all_outside_sydney" {
  policy_id = aws_organizations_policy.deny_all_outside_sydney.id
  target_id = var.target_id
}


variable "target_id" {
  description = "AWS account, OU or root ID to attach the SCP to"
  type        = string
}
