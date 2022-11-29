module "codepipeline" {
  for_each = var.pipeline
  source   = "./modules/codepipeline"

  project = var.project
  env     = var.env
  key     = each.key

  codepipeline_bucket_name = var.codepipeline_bucket_name
  codepipeline_bucket_arn  = aws_s3_bucket.codepipeline_bucket.arn
  codepipeline_bucket_id   = aws_s3_bucket.codepipeline_bucket.id

  codestar_connections_arn = try(each.value.CodePipeline.Source[each.value.CodePipeline.Source.Provider].ConnectionArn, "")

  codepipeline_info = {
    Source              = try(each.value.CodePipeline.Source, {})
    Approval            = try(each.value.CodePipeline.Approval, { useApprovalStage = false })
    OutputArtifacts     = try(each.value.CodePipeline.Build.OutputArtifacts, [])
    ProjectName         = module.codebuild[each.key].aws_codebuild_project_id
    Deploy              = try(each.value.CodePipeline.Deploy, { useDeployStage = false })
    common_tags         = try(local.common_tags, {})
  }
}