project = "mzc-swat"
env     = "test"
region  = "ap-northeast-2"

codepipeline_bucket_name = "dev-cpp-codepipeline-artifact"

default_tags = {
  dept      = "PSA Group / DevOps SWAT Team"
  i_service = "CloudPlex"
  email     = "lhdong@mz.co.kr"
  purpose   = "Pipeline"
}

pipeline = {
    MzcTest1 = {
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
                        ConnectionArn = "arn:aws:codestar-connections:ap-northeast-2:179248873946:connection/a0807f60-eb1c-4f6a-aea6-c9b85977769b"
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

        Approval = {
            useApprovalStage = false
            approval_group_name = ""                
        }

        CodeBuild = {
            Description  = "test desc"
            BuildTimeout = "60"

            codebuild_source_credential = {                
                auth_type   = "BASIC_AUTH"
                server_type = "BITBUCKET"
                token       = "5dRjPC36dpubwrZWMRxB"
                user_name   = "leehodong"
            }

            artifacts = {
                type = "CODEPIPELINE"
                path = "codebuild-artifacts"
            }

            cache = {
                type = "LOCAL"
                modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
            }

            environment = {
                compute_type                = "BUILD_GENERAL1_LARGE"
                image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
                type                        = "LINUX_CONTAINER"
                image_pull_credentials_type = "CODEBUILD"
                privileged_mode             = true
            }            

            environment_variables = {
                "DOMAIN_NAME" = { val = "space", type = "PLAINTEXT" },
                "BITBUCKET_PASSWORD" = { val = "devops-bitbucket:password", type = "SECRETS_MANAGER" }
            }

            secondary_sources = {
                type = "BITBUCKET"
                source_identifier = "root"
                location = "https://leehodong@bitbucket.org/megazone/mzc-kraken"
                git_clone_depth = "1"
            }

            secondary_source_version = {
                source_identifier = "root"
                source_version = "main"
            }
            
            # True if buildspec is located in source repo 
            useBuildspecPath = false
            buildspec_path = "apps/buildspec-dev.yml"
            buildspec_yaml = "templates/buildspec.yaml"
        }
    },
}