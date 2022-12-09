module "codepipeline" {
  for_each = var.pipeline
  source   = "./modules/codepipeline"

  project = var.project
  env     = var.env
  key     = each.key

  codepipeline_bucket_name = var.codepipeline_bucket_name
  codepipeline_bucket_arn  = aws_s3_bucket.codepipeline_bucket.arn
  codepipeline_bucket_id   = aws_s3_bucket.codepipeline_bucket.id

  codestar_connections_arn = try(each.value.StageList[0].Configuration.ConnectionArn, "*")
  stagelist                = each.value.StageList
  approval                 = try(each.value.Approval, { useApprovalStage = false })
  project_name             = module.codebuild[each.key].aws_codebuild_project_id
  common_tags              = try(local.common_tags, {})
  
}