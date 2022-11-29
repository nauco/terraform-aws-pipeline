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
        # codepipeline module
        CodePipeline = {
            # 암호화 키 (미구현)

            Source = {
                ActionName = "Source"
                Category = "Source"
                # AWS, Custom, ThirdParty
                Owner = "AWS"
                ActionName = "Source"
                # Provider = "Bitbucket", "S3", "ECR", "CodeCommit", "GitHub", "GithubEnterpriseServer"
                Provider = "GitHub"
                OutputArtifact = ["source_output"]
                Version = "1"

                # Source Provider Configuration
                # AWS CodeCommit
                CodeCommit = {
                    Provider = "CodeCommit"
                    RepositoryName = ""
                    BranchName = ""
                    ChangeDetectionOptions = ""
                    OutputArtifactFormat = ""
                }

                # Amazon ECR
                ECR = {
                    Provider = "ECR"
                    RepositoryName = ""
                    #defaults to latest
                    ImageTag = ""
                }

                # Amazon S3
                S3 = {
                    Provider = "S3"
                    BucketName = ""
                    #처음에 / 넣지말고, 확장자 포함
                    S3ObjectKey = ""
                }

                # Bitbucket
                Bitbucket = {
                    Provider = "CodeStarSourceConnection"
                    ConnectionArn = "arn:aws:codestar-connections:ap-northeast-2:179248873946:connection/a0807f60-eb1c-4f6a-aea6-c9b85977769b"
                    # <account>/<repository-name>
                    FullRepositoryId = "megazone/mzc-space"
                    BranchName = "main"
                }
                #GitHub
                GitHub = {
                    Provider = "CodeStarSourceConnection"
                    ConnectionArn = "arn:aws:codestar-connections:ap-northeast-2:179248873946:connection/d6b1d668-6c5b-4122-94b3-f06ebac95a81"
                    FullRepositoryId = "nauco/devops_ojt"
                    BranchName = "main"
                }

                #GithubEnterpriseServer
                GithubEnterpriseServer = {
                    Provider = "CodeStarSourceConnection"
                    ConnectionArn = ""
                    FullRepositoryId = ""
                    BranchName = ""
                }             
            }

            Approval = {
                useApprovalStage = false
                approval_group_name = ""                
            }

            Build = {
                OutputArtifacts = ["build_output"]
            }

            Deploy = {
                useDeployStage = true
                
                ActionName = "Deploy"
                Category = "Deploy"
                # AWS, Custom, ThirdParty
                Owner = "AWS"
                # Provider = S3, CloudFormation, CodeDeploy, CodeDeployToECS
                Provider = "S3"
                InputArtifacts = ["build_output"]    
                Version = "1"
                            
                # Deploy Provider Configuration
                CloudFormation = {
                    ActionMode     = "REPLACE_ON_FAILURE"
                    Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
                    OutputFileName = "CreateStackOutput.json"
                    StackName      = "MyStack"
                    TemplatePath   = "build_output::sam-templated.yaml"
                }

                S3 = {
                    BucketName = "dev-cpp-codepipeline-artifact"
                    Extract    = "false"
                    ObjectKey  = "deploy-file"
                }

                CodeDeploy = {
                    ApplicationName     = "my-application"
                    DeploymentGroupName = "my-deployment-group"
                }

                CodeDeployToECS = {
                    AppSpecTemplateArtifact        = "SourceArtifact"
                    ApplicationName                = "ecs-cd-application"
                    DeploymentGroupName            = "ecs-deployment-group"
                    Image1ArtifactName             = "MyImage"
                    Image1ContainerName            = "IMAGE1_NAME"
                    TaskDefinitionTemplatePath     = "taskdef.json"
                    AppSpecTemplatePath            = "appspec.yaml"
                    TaskDefinitionTemplateArtifact = "SourceArtifact"
                }
            }

        },

        # codebuild module
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
    }
}