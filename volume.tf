provider "netapp-cloudmanager" {
  refresh_token = "E9SgA-0LzUKos5Z7-nx6reey7aypYolF6v_oA5mCIisZV"
}
resource "netapp-cloudmanager_volume" "cvo-volume-nfs" {
  provider = netapp-cloudmanager
  volume_protocol = "nfs"
  name = "vol1"
  size = 10
  unit = "GB"
  provider_volume_type = "pd-standard"
  export_policy_type = "custom"
  export_policy_ip = ["0.0.0.0/0"]
  export_policy_nfs_version = ["nfs4"]
  aggregate_name = "aggr2"
  capacity_tier = "none"
  working_environment_id = "vsaworkingenvironment-ycnwkjrk"
  client_id = "4GjXhbZISRGRakXqzAUIfIQOlaSe0PPe"
}