module "codepipeline" {
  for_each = var.pipeline
  source   = "./modules/codepipeline"

  prefix                   = var.prefix
  codepipeline_bucket_name = var.codepipeline_bucket_name
  codepipeline_bucket_arn  = aws_s3_bucket.codepipeline_bucket.arn
  codepipeline_bucket_id   = aws_s3_bucket.codepipeline_bucket.id

  codestar_connections_arn = var.codestar_connections_arn

  codepipeline_info = {
    PipelineName        = try(each.value.CodePipeline.PipelineName, "")
    Source              = try(each.value.CodePipeline.Source, {})
    useApprovalStage    = try(each.value.Approval.useApprovalStage, false)
    approval_group_name = try(each.value.Approval.approval_group_name, "")
    OutputArtifacts     = try(each.value.CodePipeline.Build.OutputArtifacts, [])
    ProjectName         = module.codebuild[each.key].aws_codebuild_project_id
    PipelineTags        = try(each.value.CodePipeline.PipelineTags, {})
  
  }
}