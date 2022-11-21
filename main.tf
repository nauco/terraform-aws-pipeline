provider "aws" {
  region  = "ap-northeast-2"

  default_tags {
    tags = var.common_tags
  }
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = var.codepipeline_bucket_name
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  acl    = "private"
}

resource "aws_codepipeline" "codepipeline" {
  for_each = var.pipeline

  name     = format("%s%s", var.prefix, each.value.CodePipeline.PipelineName)
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = each.value.CodePipeline.PipelineName

    dynamic "action" {
      for_each = length(each.value.CodePipeline.Source) > 0 ? [each.value.CodePipeline.Source] : []

      content {
        name             = action.value.ActionName
        category         = action.value.Category
        owner            = action.value.Owner
        provider         = each.value.CodePipeline[action.value.Provider].Provider
        version          = action.value.Version
        output_artifacts = action.value.OutputArtifact

        configuration = {
          for k, v in each.value.CodePipeline[action.value.Provider]: k => v
          if k != "Provider"
        }
        
      }
    }
  }

  dynamic "stage" {
    for_each = each.value.Approval.build_approval ? [1] : []

    content {
      name = "Approval"

      action {
        name             = "Approval"
        category         = "Approval"
        owner            = "AWS"
        version          = "1"
        provider         = "Manual"
      }
    }
  }  

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = each.value.CodePipeline.Build.OutputArtifacts
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.codebuild[each.key].id
      }
    }
  }

  dynamic "stage" {
    for_each = each.value.CodeDeploy.useDeployStage ? [1] : []
         

    content {
      name            = each.value.CodeDeploy.stageName


      action {
        name            = each.value.CodeDeploy.stageName
        category        = each.value.CodeDeploy.Deploy.Category
        owner           = each.value.CodeDeploy.Deploy.Owner
        provider        = each.value.CodeDeploy.Deploy.Provider
        input_artifacts = each.value.CodeDeploy.Deploy.InputArtifacts
        version         = each.value.CodeDeploy.Deploy.Version

        configuration = tomap(each.value.CodeDeploy.CloudFormation)
      

      }
      
    }    
  }

  tags = each.value.CodePipeline.PipelineTags

}


resource "aws_iam_role" "codepipeline_role" {
  name = format("%scodepipeline-role-%s", var.prefix, random_string.random.result)

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = format("%scodepipeline-policy-%s", var.prefix, random_string.random.result)
  
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_bucket.arn}",
        "${aws_s3_bucket.codepipeline_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codestar-connections:UseConnection"
      ],
      "Resource": "${var.codestar_connections_arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Attach approval policy to IAM Group
data "aws_iam_group" "approval_group" {
  count      = var.approval_group_name == "" ? 0 : 1

  group_name = var.approval_group_name 
}

resource "aws_iam_policy" "approval_policy" {
  count       = var.approval_group_name == "" ? 0 : 1

  name = format("%sapproval-policy-%s", var.prefix, random_string.random.result)
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "codepipeline:GetPipeline",
                "codepipeline:GetPipelineState",
                "codepipeline:GetPipelineExecution",
                "codepipeline:ListPipelineExecutions",
                "codepipeline:ListPipelines",
                "codepipeline:PutApprovalResult"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF   
}

resource "aws_iam_group_policy_attachment" "approval_policy_attach" {
  count       = var.approval_group_name == "" ? 0 : 1
  
  group      = data.aws_iam_group.approval_group[count.index].group_name
  policy_arn = aws_iam_policy.approval_policy[count.index].arn
}