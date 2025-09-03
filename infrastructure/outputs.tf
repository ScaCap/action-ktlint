output "codedeploy_application_name" {
  value = module.code_deploy.deployment_name
}

output "codedeploy_group_name" {
  value = module.code_deploy.deployment_group_id
}

output "appspec_s3" {
  value = data.terraform_remote_state.shared.outputs.appspec_bucket_name
}

output "appspec_key" {
  value = module.app_spec.deployment_group_id
}

output "region" {
  value = "eu-central-1"
}
