# Cloud Volumes ONTAP Single Node on Google Cloud using Terraform

The module parameters and details can be checked in the official documentation: [NetApp Cloud Manager CVO for GCP](https://registry.terraform.io/providers/NetApp/netapp-cloudmanager/latest/docs/resources/cvo_gcp).

* [Requirements](#requirements)
* [Deployment](#deployment)

## Requirements

### NetApp Cloud Central refresh token

A refresh token is needed to obtain an access tokens for users. Log in with your credentiales in [https://services.cloud.netapp.com/refresh-token](https://services.cloud.netapp.com/refresh-token) to get the refresh token. 

1. Click on the generate refresh token button.

![token-generator1](./../pics/cloudmanager_token_generator01.jpg)

2. Copy it to the clipboard.

![token-generator2](./../pics/cloudmanager_token_generator02.jpg)

### Service account for the Cloud Volumes ONTAP

Create a service account for the CVO instance to be able to tier to GCS and/or backup & restore to GCS. The public [documentation](https://docs.netapp.com/us-en/cloud-manager-cloud-volumes-ontap/task-creating-gcp-service-account.html) shows the steps and required permissions.

### Cloud Manager Connector Client id

1. Go to [Cloud Manager SaaS](https://cloudmanager.netapp.com/support-dashboard/connector), and click on the question mark icon on the top right and click on 'Support'. Click on the 'Connector' section. Copy the Client id.

![account-id1](./../pics/cloudmanager_client_id01.jpg)


### Cloud Manager Workspace id

1. Go to [Cloud Manager SaaS](https://cloudmanager.netapp.com/), and click on the workspace section on the top right and click on the three dots. Copy the workspace id.

![account-id1](./../pics/cloudmanager_workspace_id01.jpg)

## Deployment

Check the last Terraform module version and modify the inputs according with your project.

provider.tf
```yaml
terraform {
  required_providers {
    netapp-cloudmanager = {
      source = "NetApp/netapp-cloudmanager"
      version = "22.8.3"
    }
  }
}
```

cvosn.tf
```yaml
provider "netapp-cloudmanager" {
  refresh_token = "E9SgA-0LzUKos5Z7-nx6reey7aypYolF6v_oA5mCIisZV"
}
resource "netapp-cloudmanager_cvo_gcp" "cvo-gcp" {
  provider = netapp-cloudmanager
  name = "cvosn"
  zone = "us-east4-b"
  project_id = "rt1882669"
  vpc_id = "gcp-vpc-core"
  subnet_id = "gcp-vpc-core-private"
  gcp_service_account = "storageadmin@rt1882669.iam.gserviceaccount.com"
  svm_password = "Netapp1!"
  license_type = "capacity-paygo"
  capacity_package_name = "Freemium"
  instance_type = "n2-standard-32"
  writing_speed_state = "NORMAL"
  gcp_volume_type = "pd-standard"
  gcp_volume_size = 1
  gcp_volume_size_unit = "TB"
  client_id = "4GjXhbZISRGRakXqzAUIfIQOlaSe0PPe"
  workspace_id = "workspaceNpcz5Xxy"
}
```

Run it using the below command:
```shell
terraform apply
```