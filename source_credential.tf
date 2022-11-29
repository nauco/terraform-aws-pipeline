resource "aws_codebuild_source_credential" "bitbucket" {
  for_each = var.pipeline
  
  auth_type   = each.value.CodeBuild.codebuild_source_credential.auth_type
  server_type = each.value.CodeBuild.codebuild_source_credential.server_type
  token       = each.value.CodeBuild.codebuild_source_credential.token
  user_name   = each.value.CodeBuild.codebuild_source_credential.user_name
}