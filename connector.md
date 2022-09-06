# Cloud Volumes Connector on Google Cloud using Terraform

The module parameters and details can be checked in the official documentation:
[NetApp Cloud Manager connector for GCP](https://registry.terraform.io/providers/NetApp/netapp-cloudmanager/latest/docs/resources/connector_gcp).

* [Requirements](#requirements)
* [Deployment](#deployment)

## Requirements

### NetApp Cloud Central refresh token

A refresh token is needed to obtain an access tokens for users. Log in with your credentiales in [https://services.cloud.netapp.com/refresh-token](https://services.cloud.netapp.com/refresh-token) to get the refresh token. 

1. Click on the generate refresh token button.

![token-generator1](./pics/cloudmanager_token_generator01.jpg)

2. Copy it to the clipboard.

![token-generator2](./pics/cloudmanager_token_generator02.jpg)

### Service account for the Cloud Manager Connector

Create a service account on Google Cloud for the connector as the documentation shows [here](https://docs.netapp.com/us-en/cloud-manager-setup-admin/task-creating-connectors-gcp.html#set-up-a-service-account-for-the-connector). You can use the Google Cloud Shell with the below commands:

```shell
myproject=xxxxxx              # <- Set your project id
gcloud config set project $myproject

curl https://occm-sample-policies.s3.amazonaws.com/Policy_for_Cloud_Manager_3.9.10_GCP.yaml -o Policy_for_Cloud_Manager_3.9.10_GCP.yaml

gcloud iam roles create CM_Connector --project=$myproject --file=Policy_for_Cloud_Manager_3.9.10_GCP.yaml

gcloud iam service-accounts create netapp-connector --description="Service account associated with the NetApp Cloud Manager Connector" --display-name="NetApp Connector"

gcloud projects add-iam-policy-binding $myproject --member="serviceAccount:netapp-connector@$myproject.iam.gserviceaccount.com" --role=projects/$myproject/roles/CM_Connector
```

Once you have created the service account, [create a key](https://cloud.google.com/iam/docs/creating-managing-service-account-keys) and download the json file as 'tf-connector.json'.

### Cloud Manager Account id

1. Go to [Cloud Manager SaaS](https://cloudmanager.netapp.com/), and click on the Account menu on the top right. Click on the 'Manage Account' section.

![account-id1](./pics/cloudmanager_account_id01.jpg)

2. Copy the Account ID.

![account-id2](./pics/cloudmanager_account_id02.jpg)

## Deployment

Check the last Terraform module version and modify the inputs according to your project.

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

connector.tf
```yaml
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
