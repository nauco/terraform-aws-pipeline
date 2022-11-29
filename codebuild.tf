module "codebuild" {
  for_each = var.pipeline
  source   = "./modules/codebuild"
  
  project = var.project
  env     = var.env
  key     = each.key
  
  codepipeline_bucket_arn = aws_s3_bucket.codepipeline_bucket.arn
  codepipeline_bucket_id  = aws_s3_bucket.codepipeline_bucket.id  

  codebuild_info = {
    description              = try(each.value.CodeBuild.Description, "")
    build_timeout            = try(each.value.CodeBuild.BuildTimeout, "")
    artifacts                = try(each.value.CodeBuild.artifacts, {})
    cache                    = try(each.value.CodeBuild.cache, {})
    environment              = try(each.value.CodeBuild.environment, {})
    environment_variables    = try(each.value.CodeBuild.environment_variables, {})
    useBuildspecPath         = try(each.value.CodeBuild.useBuildspecPath, true)
    buildspec_path           = try(each.value.CodeBuild.buildspec_path, "")
    buildspec_yaml           = try(each.value.CodeBuild.buildspec_yaml, "")
    secondary_sources        = try(each.value.CodeBuild.secondary_sources, {})
    secondary_source_version = try(each.value.CodeBuild.secondary_source_version, {})
    common_tags              = try(local.common_tags, {})
  }
}