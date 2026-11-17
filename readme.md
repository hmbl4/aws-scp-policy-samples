
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
Gaps / acceptable risk | Root account credentials can still disable cloud trail.  |
| Verification test | Run a test from an inscope authenticated principal.  |

## 3. regions-disable.tf

| Field | Notes |
| --- | --- |
| What it blocks | If an organisation and/or customer base is concentrated in one location, we'd look to block actions outside ap-southeast-2 (Sydney). The control prevents users from accessing non-global services in any other region apart from ap-southeast-2. |
| Principals in scope | All principals in the AWS account, no exceptions  |
| Attacker outcome it prevents | Prevents attackers from spinning up infrastructure from other regions where monitoring may not be robust. |
| Attack stage interrupted | Evading further creation, deletion, changes of infrastructure to all regions outside Sydney. |
| What gets past it | Anyone doing actions in the root account, unlikely, but should be accounted for. Any resources that were previously running will also continue to run, this SCP doesn't stop them. |
| Verification test | Run a test from an inscope authenticated principal in a different region.  |
