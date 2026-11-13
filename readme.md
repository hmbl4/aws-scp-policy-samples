
# AWS SCP Policy samples

Attached in the `/policies` folder are some sample terraform files that enforce a number of policies within AWS, and below are descriptions of each.

- **block-public-s3-buckets.tf** - Blocks the ability for S3 buckets to be made public. 
- **cloudtrail-disable.tf** - Prevents Cloudtrail from being disabled. 
- **iam-no-actions-without-mfa.tf** - Prevents actions in an account unless the user has configured and enabled MFA.
- **regions-disable.tf** - Prevents actions outside of defined regions, in this example `ap-southeast-2` (Sydney). 


### File structure 

```
├── main.tf
├── policies
│   ├── block-public-s3-buckets.tf
│   ├── cloudtrail-disable.tf
│   ├── iam-no-actions-without-mfa.tf
│   └── regions-disable.tf
├── readme.md
└── terraform.tfvars
```

# AWS SCP Threat Model

Project: SCP guardrails for AWS member accounts (`/policies` folder: four Terraform SCPs).

> AI was used to create the structure for the threat model. It was not used to formulate the answers.

## Scope and asset

| Field | Notes |
| --- | --- |
| Primary asset | Employee records (PII) stored in S3 buckets |
| Worst-case outcome | Data copied out of the organisation |
| Bucket exposure | Public bucket (anonymous internet access) and bucket reachable only from inside the account (authenticated principals with stolen or misused credentials) |
| Adversaries to consider | Stolen access key, phished console user, insider, well-meaning engineer, high-privilege attacker |
| Assumptions |  |

## 1. block-public-s3-buckets.tf

| Field | Notes |
| --- | --- |
| What it blocks | Changing S3 buckets permission from private to public |
| Principals in scope | All principals in the AWS account, no exceptions |
| Attacker outcome it prevents | Prevents a principal from removing public access block on an S3 bucket.  |
| Attack stage interrupted | An attacker preparing for exfiltration of data. |
| What gets past it | Authenticated / authorised principals with valid credentials reading a private bucket |
| Gaps / acceptable risk | An authenticated user can still read the private bucket's contents.  |
| Verification test | An unauthenticated principal attempts to access the bucket outside of the AWS account  |

## 2. cloudtrail-disable.tf

| Field | Notes |
| --- | --- |
| What it blocks | Disabling CloudTrail |
| Principals in scope | All principals in the AWS account, no exceptions |
| Attacker outcome it prevents | Prevents an authenticated principal from stopping or deleting cloud trail logs.  |
| Attack stage interrupted | Evade defence - an attacker preparing to perform malicious activities of an account, could disable logging services as a precursor so that logs are not recorded.  |
| What gets past it | Root account privileges can still be bypassed. Principals can still update the CT configuration, e.g. the  `UpdateTrail` Action. |
| \
Gaps / acceptable risk | Root account credentials can still disable cloud trail.  |
| Verification test | Run a test from an inscope authenticated principal.  |

## 3. iam-no-actions-without-mfa.tf

| Field | Notes |
| --- | --- |
| What it blocks | Actions unless the user has MFA configured and enabled |
| Principals in scope | All principals in the AWS account, no exceptions |
| Attacker outcome it prevents | Use of AWS services in the account, without MFA configured on the current principals account.  |
| Attack stage interrupted | Restricted actions can't be called. Will delay attacker from calling further commands.  |
| What gets past it | An attacker can enrol their own MFA device, then enable the control |
| Exempt actions to check | MFA enrolment actions. What else is exempt? Creation of access keys, changing passwords. |
| Credential types covered | Console sessions: to confirm. Long-lived access keys: to confirm. |
| Gaps / acceptable risk |  |
| Verification test |  |

## 4. regions-disable.tf

| Field | Notes |
| --- | --- |
| What it blocks | Actions outside ap-southeast-2 (Sydney) |
| Principals in scope |  |
| Attacker outcome it prevents |  |
| Attack stage interrupted |  |
| What gets past it |  |
| Gaps / acceptable risk |  |
| Verification test |  |
