# CodePipeline

# 소개
AWS CodePipeline

## Resources
| Name                                                                                                                                                              | Type     |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_codepipeline.codepipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline)                                         | resource |
| [aws_iam_role.codepipeline_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                           | resource |
| [aws_iam_role_policy.codepipeline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy)                            | resource |
| [aws_iam_group.approval_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group)                                             | data     |
| [aws_iam_policy.approval_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                          | resource |
| [aws_iam_group_policy_attachment.approval_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)                                                     | resource |


## Inputs
|이름|설명|필수구분 |입력부분|
| -- | ------ | ---- | --- |
| project                               | 프로젝트 이름                                                                                                                                                                                             | yes      |
| region                                | AWS 리전 정보 (e.g. ap-northeast-2)                                                                                                                                                                       | yes      |
| env                                   | tag 생성을 위한 입력 값 (e.g. dev, stg, ...)                                                                                                                                                              | yes      |
| codestar_connections_arn              | code star connection arn                                                                                                                                                                                  | yes      |
| aws_codebuild_source_credential_token | bitbucket token                                                                                                                                                                                           | yes      |
| codepipeline_bucket_name              | codepipeline artifact bucket                                                                                                                                                                              | yes      |



예제

```
        StageList = [
            {
                Stage = "Source"
                StageName = "ABC"
                Actions = [{
                    ActionName = "S1"
                    Owner = "AWS"
                    RunOrder = 1
                    Provider = "CodeStarSourceConnection"
                    InputArtifacts = []
                    OutputArtifacts = ["source_output1"]
                    Version = "1"
                    Configuration = {
                        ConnectionArn = "arn:aws:codestar-connections:ap-northeast-2:111122223333:connection/abcdefgh-eb1c-4f6a-aea6-c9b85977769b"
                        # <account>/<repository-name>
                        FullRepositoryId = "megazone/mzc-space"
                        BranchName = "main"
                        DetectChanges = "true"
                    }
                }, 
                {
                    ActionName = "S2"
                    Owner = "AWS"
                    RunOrder = 1
                    Provider = "ECR"
                    InputArtifacts = []
                    OutputArtifacts = ["source_output2"]
                    Version = "1"
                    Configuration = {
                        RepositoryName = "sample-sqs-consumer"
                        #defaults to latest
                        ImageTag = "latest"
                    }

                },
                {
                    ActionName = "S3"
                    Owner = "AWS"
                    RunOrder = 2
                    Provider = "S3"
                    InputArtifacts = []
                    OutputArtifacts = ["source_output3"]
                    Version = "1"
                    Configuration =  {
                        S3Bucket = "dev-cpp-codepipeline-artifact"
                        #처음에 / 넣지말고, 확장자 포함
                        S3ObjectKey = "dev/test"
                    }   
                }, 
                {
                    ActionName = "S4"
                    Owner = "AWS"
                    RunOrder = 2
                    Provider = "CodeCommit"
                    InputArtifacts = []
                    OutputArtifacts = ["source_output4"]
                    Version = "1"
                    Configuration =  {
                        RepositoryName = "mz.cloudplex.guide"
                        BranchName = "main"
                        PollForSourceChanges = "true"
                        OutputArtifactFormat = "CODE_ZIP"
                    }   
                }]
            },
            {
                Stage = "Approval"
                StageName = "APPROVE"
                Actions = [{
                    ActionName = "AAA"
                    Owner = "AWS"
                    RunOrder = 1
                    Provider = "Manual"
                    InputArtifacts = []
                    OutputArtifacts = [""]
                    Version = "1"
                    Configuration =  {}   
                }]
            },
            {
                Stage = "Build"
                StageName = "BBBB"
                Actions = [{
                    ActionName = "B1"
                    Owner = "AWS"
                    RunOrder = 1
                    Provider = "CodeBuild"
                    InputArtifacts = ["source_output1", "source_output2"]
                    OutputArtifacts = ["build_output1"]
                    Version = "1"
                    Configuration = {}
                },
                {
                    ActionName = "B2"
                    Owner = "AWS"
                    RunOrder = 2
                    Provider = "CodeBuild"
                    InputArtifacts = ["source_output3"]
                    OutputArtifacts = ["build_output2"]
                    Version = "1"
                    Configuration = {}
                }]
            },
            {
                Stage = "Deploy"
                StageName = "DDD"
                Actions = [{
                    ActionName = "D1"
                    Owner = "AWS"
                    RunOrder = 1
                    Provider = "CodeDeploy"
                    InputArtifacts = ["build_output1"]
                    OutputArtifacts = []
                    Version = "1"
                    Configuration = {
                        ApplicationName     = "my-application"
                        DeploymentGroupName = "my-deployment-group"
                    }
                },
                {
                    ActionName = "D2"
                    Owner = "AWS"
                    RunOrder = 1
                    Provider = "CloudFormation"
                    InputArtifacts = ["build_output1"]
                    OutputArtifacts = []
                    Version = "1"
                    Configuration = {
                        ActionMode     = "REPLACE_ON_FAILURE"
                        Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
                        OutputFileName = "CreateStackOutput.json"
                        StackName      = "MyStack"
                        TemplatePath   = "build_output::sam-templated.yaml"
                    }
                },
                {
                    ActionName = "D3"
                    Owner = "AWS"
                    RunOrder = 2
                    Provider = "S3"
                    InputArtifacts = ["build_output2"]
                    OutputArtifacts = []
                    Version = "1"
                    Configuration = {
                        BucketName = "dev-cpp-codepipeline-artifact"
                        Extract    = "false"
                        ObjectKey  = "deploy-file"
                    }
                },
                {
                    ActionName = "D4"
                    Owner = "AWS"
                    RunOrder = 2
                    Provider = "CodeDeployToECS"
                    InputArtifacts = ["build_output1", "build_output2"]
                    OutputArtifacts = []
                    Version = "1"
                    Configuration = {
                        AppSpecTemplateArtifact        = "SourceArtifact"
                        ApplicationName                = "ecs-cd-application"
                        DeploymentGroupName            = "ecs-deployment-group"
                        Image1ArtifactName             = "MyImage"
                        Image1ContainerName            = "IMAGE1_NAME"
                        TaskDefinitionTemplatePath     = "taskdef.json"
                        AppSpecTemplatePath            = "appspec.yaml"
                        TaskDefinitionTemplateArtifact = "SourceArtifact"
                    }
                }]
            }
        ]
```
