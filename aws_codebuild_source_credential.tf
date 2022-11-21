resource "aws_codebuild_source_credential" "bitbucket" {
  count       = var.aws_codebuild_source_credential_bitbucket_token == "" ? 0 : 1
  
  auth_type   = "BASIC_AUTH"
  server_type = "BITBUCKET"
  token       = var.aws_codebuild_source_credential_bitbucket_token
  user_name   = "leehodong"
}