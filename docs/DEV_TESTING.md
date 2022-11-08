# Testing

## Smoke Tests matrix: Terraform Validate

GitHub Actions will perform Terraform Validate for each commit to the Git repository.

**Note:** The GitHub Action will loop according to the SAP Solution Scenario and the Infrastructure Platform, if a Terraform Template does not exist for this combination then it will display as a `fail`.


## End to End (E2E) / User Acceptance Tests (UAT) matrix: Terraform Apply


## Future improvements pending Terraform changes

- `raise` feature for custom error message in Terraform -> [terraform/issues/24269](https://github.com/hashicorp/terraform/issues/24269) / [terraform/pull/25088](https://github.com/hashicorp/terraform/pull/25088)
