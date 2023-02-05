# Cloud Volumes ONTAP on Google Cloud using Terraform

Cloud Manager Connector using Standalone VPC

## Code

Check the last Terraform module version and modify the inputs according to your project.

my-connector.tf
```yaml
terraform {
  required_providers {
    netapp-cloudmanager = {
      source = "NetApp/netapp-cloudmanager"
      version = "23.1.1"
    }
  }
}

provider "netapp-cloudmanager" {
  refresh_token = "VZzwMXHb_NTr0nxfwbPMgihFC3KOXe2s71wf6fsXvLPhU"
}
resource "netapp-cloudmanager_connector_gcp" "cm-gcp" {
  provider = netapp-cloudmanager
  name = "my-connector"
  project_id = "rt1882492"
  zone = "us-east4-b"
  subnet_id = "gcp-vpc-core-private"
  company = "NetApp"
  service_account_email = "netapp-connector@rt1882492.iam.gserviceaccount.com"
  service_account_path = "tf-connector.json"
  account_id = "account-C7RqYv1X"
}
```

Run it using the below command:
```shell
terraform apply
```