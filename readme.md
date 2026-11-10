
## AWS SCP Policy samples

Attached in the `policies` folder are some sample terraform files that enforce a number of policies within AWS. Below are descriptions of each.

*block-public-s3-buckets.tf* - Blocks the ability for S3 buckets to be made public. 
*cloudtrail-disable.tf* - Prevents Cloudtrail from being disabled. 
*iam-no-actions-without-mfa.tf* - Prevents actions in an account unless the user has configured and enabled MFA.
*regions-disable.tf* - Prevents actions outside of defined regions, in this example `ap-southeast-2` (Sydney). 


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