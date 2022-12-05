resource "aws_iam_role" "codepipeline_role" {
  name = format("%s-codepipeline-role-%s", var.key, random_string.random.result)

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
  name = format("%s-codepipeline-policy-%s", var.key, random_string.random.result)
  
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
        "${var.codepipeline_bucket_arn}",
        "${var.codepipeline_bucket_arn}/*"
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

#############################################
###  Attach approval policy to IAM Group  ###
#############################################
data "aws_iam_group" "approval_group" {
  count      = var.approval.approval_group_name == "" ? 0 : 1

  group_name = var.approval.approval_group_name 
}

resource "aws_iam_policy" "approval_policy" {
  count       = var.approval.approval_group_name == "" ? 0 : 1

  name = format("%s-approval-policy-%s", var.key, random_string.random.result)
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
  count       = var.approval.approval_group_name == "" ? 0 : 1
  
  group      = data.aws_iam_group.approval_group[count.index].group_name
  policy_arn = aws_iam_policy.approval_policy[count.index].arn
}

resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
}