project = "cloudplex"
env = "dev"
prefix = "Test-"

# 나중엔 삭제하고 Bitbucket.ConnectionArn을 사용하는 방법으로 개발해야함.
codestar_connections_arn = "arn:aws:codestar-connections:ap-northeast-2:179248873946:connection/a0807f60-eb1c-4f6a-aea6-c9b85977769b"
aws_codebuild_source_credential_bitbucket_token = "5dRjPC36dpubwrZWMRxB"
codepipeline_bucket_name = "dev-cpp-codepipeline-artifact"

common_tags = {
  dept      = "PSA Group / DevOps SWAT Team"
  i_service = "CloudPlex"
  env       = "test"
  email     = "lhdong@mz.co.kr"
  purpose   = "Pipeline"
  managed   = "Terraform"
}

pipeline = {
    MzcTest1 = {
        #codepipeline option
        CodePipeline = {
            PipelineName = "mzc-test",

            #암호화 키 (미구현)

            Source = {
                Category = "Source"
                #AWS, Custom, ThirdParty
                Owner = "AWS"
                ActionName = "Source"
                # Provider = "Bitbucket", "S3", "ECR", "CodeCommit"
                Provider = "Bitbucket"
                Version = "1"
                OutputArtifact = ["source_output"]

                #AWS CodeCommit
                CodeCommit = {
                    Provider = "CodeCommit"
                    RepositoryName = ""
                    BranchName = ""
                    ChangeDetectionOptions = ""
                    OutputArtifactFormat = ""
                }

                #Amazon ECR
                ECR = {
                    Provider = "ECR"
                    RepositoryName = ""
                    #defaults to latest
                    ImageTag = ""
                }

                #Amazon S3
                S3 = {
                    Provider = "S3"
                    BucketName = ""
                    #처음에 / 넣지말고, 확장자 포함
                    S3ObjectKey = ""

                }

                #Bitbucket
                Bitbucket = {
                    Provider = "CodeStarSourceConnection"
                    ConnectionArn = "arn:aws:codestar-connections:ap-northeast-2:179248873946:connection/a0807f60-eb1c-4f6a-aea6-c9b85977769b"
                    # <account>/<repository-name>
                    FullRepositoryId = "megazone/mzc-space"
                    BranchName = "main"
                }

                #Github Enterprise Server

                #GitHub(버전 1)

                #GitHub(버전 2)
                
            }

            Build = {
                OutputArtifacts = ["build_output"]
            }

            Deploy = {
                useDeployStage = true
                stageName = "Deploy"

                Category = "Deploy"
                #AWS, Custom, ThirdParty
                Owner = "AWS"
                ActionName = "Deploy"
                # Provider = S3, CloudFormation, CodeDeploy, CodeDeployToECS
                Provider = "S3"
                Version = "1"
                InputArtifacts = ["build_output"]                
                

                CloudFormation = {
                    ActionMode     = "REPLACE_ON_FAILURE"
                    Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
                    OutputFileName = "CreateStackOutput.json"
                    StackName      = "MyStack"
                    TemplatePath   = "build_output::sam-templated.yaml"
                }

                S3 = {
                    BucketName = "dev-cpp-codepipeline-artifact"
                    Extract    = "true"
                    ObjectKey  = "deploy-test"
                }

                CodeDeploy = {
                    ApplicationName = "my-application"
                    DeploymentGroupName = "my-deployment-group"
                }

                CodeDeployToECS = {
                    AppSpecTemplateArtifact = "SourceArtifact"
                    ApplicationName         = "ecs-cd-application"
                    DeploymentGroupName = "ecs-deployment-group"
                    Image1ArtifactName = "MyImage"
                    Image1ContainerName = "IMAGE1_NAME"
                    TaskDefinitionTemplatePath = "taskdef.json"
                    AppSpecTemplatePath = "appspec.yaml"
                    TaskDefinitionTemplateArtifact = "SourceArtifact"
                }
            }



            PipelineTags = {
                Pipeline = "pipeline tag"
            }

        },
        #approval option
        Approval = {
            useApprovalStage = false
        }, 
        #codebuild option
        CodeBuild = {
            CodeBuildName = "mzc_test_codebuild"
            Description = "test desc"
            BuildTimeout = "60"
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
                "DOMAIN_NAME"  = { val = "space", type = "PLAINTEXT" },
                "BITBUCKET_PASSWORD"    = { val = "devops-bitbucket:password", type = "SECRETS_MANAGER" }
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

            CodeBuildTags = {
                CodeBuild = "build tag"                
            }
            
            # True if buildspec is located in source repo 
            useBuildspecPath = false
            buildspec_path = "apps/buildspec-dev.yml"
            buildspec_yaml = "templates/buildspec.yaml"
        },

        
    },


    # MzcSpace = {
    #     #codepipeline option
    #     CodePipeline = {
    #         Name = "space-rest-api",
    #         FullRepositoryId = "megazone/mzc-space",
    #         BranchName = "main",

    #         #not use below variable
    #         source = "Bitbucket",
    #         config_path = "mzc-space/rest-api"
    #     },
    #     #approval option
    #     Approval = {
    #         useApprovalStage = false
    #     }, 
    #     #codebuild option
    #     CodeBuild = {
    #         artifacts = {
    #             type = "CODEPIPELINE"
    #             path = "codebuild-artifacts"
    #         }

    #         cache = {
    #             type = "LOCAL"
    #             modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
    #         }

    #         environment = {
    #             compute_type                = "BUILD_GENERAL1_LARGE"
    #             image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    #             type                        = "LINUX_CONTAINER"
    #             image_pull_credentials_type = "CODEBUILD"
    #             privileged_mode             = true
    #         }            

    #         environment_variables = {
    #             "DOMAIN_NAME"  = { val = "space", type = "PLAINTEXT" },
    #             "GRADLE_ENV"   = { val = "dev", type = "PLAINTEXT" },
    #             "AWS_DEFAULT_REGION"   = { val = "ap-northeast-2", type = "PLAINTEXT" },
    #             "APP_NAME"   = { val = "space-rest-api", type = "PLAINTEXT" },
    #             "CONTAINER_NAME"   = { val = "space-rest-api", type = "PLAINTEXT" },
    #             "DOCKERHUB_USER" = { val = "mzc-cpd-codebuild-docker-hub:username", type = "SECRETS_MANAGER" },
    #             "DOCKERHUB_PASS"    = { val = "mzc-cpd-codebuild-docker-hub:password", type = "SECRETS_MANAGER" },
    #             "BITBUCKET_PASSWORD"    = { val = "devops-bitbucket:password", type = "SECRETS_MANAGER" }
    #         }

    #         secondary_sources = {
    #             type = "BITBUCKET"
    #             source_identifier = "root"
    #             location = "https://leehodong@bitbucket.org/megazone/mzc-kraken"
    #             git_clone_depth = "1"
    #         }

    #         secondary_source_version = {
    #             source_identifier = "root"
    #             source_version = "main"
    #         }
            
    #         # True if buildspec is located in source repo 
    #         useBuildspecPath = true
    #         buildspec_path = "apps/space-rest-api/buildspec-dev.yml"
    #         buildspec_yaml = "templates/buildspec.yaml"
    #     }    
    # },

    # MzcProduct = {
    #     #codepipeline option
    #     CodePipeline = {
    #         Name = "product-rest-api",
    #         FullRepositoryId = "megazone/mzc-product",
    #         BranchName = "main",

    #         #not use below variable
    #         source = "Bitbucket",
    #         config_path = "mzc-product"
    #     },
    #     #approval option
    #     Approval = {
    #         useApprovalStage = false
    #     },         
    #     #codebuild option
    #     CodeBuild = {
    #         artifacts = {
    #             type = "CODEPIPELINE"
    #             path = "codebuild-artifacts"
    #         }

    #         cache = {
    #             type = "LOCAL"
    #             modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
    #         }

    #         environment = {
    #             compute_type                = "BUILD_GENERAL1_LARGE"
    #             image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    #             type                        = "LINUX_CONTAINER"
    #             image_pull_credentials_type = "CODEBUILD"
    #             privileged_mode             = true
    #         }  

    #         environment_variables = {
    #             "DOMAIN_NAME"  = { val = "product", type = "PLAINTEXT" },
    #             "GRADLE_ENV"   = { val = "dev", type = "PLAINTEXT" },
    #             "AWS_DEFAULT_REGION"   = { val = "ap-northeast-2", type = "PLAINTEXT" },
    #             "APP_NAME"   = { val = "product-rest-api", type = "PLAINTEXT" },
    #             "CONTAINER_NAME"   = { val = "product-rest-api", type = "PLAINTEXT" },
    #             "DOCKERHUB_USER" = { val = "mzc-cpd-codebuild-docker-hub:username", type = "SECRETS_MANAGER" },
    #             "DOCKERHUB_PASS"    = { val = "mzc-cpd-codebuild-docker-hub:password", type = "SECRETS_MANAGER" },
    #             "BITBUCKET_PASSWORD"    = { val = "devops-bitbucket:password", type = "SECRETS_MANAGER" }
    #         }

    #         secondary_sources = {
    #             type = "BITBUCKET"
    #             source_identifier = "root"
    #             location = "https://leehodong@bitbucket.org/megazone/mzc-kraken"
    #             git_clone_depth = "1"
    #         }

    #         secondary_source_version = {
    #             source_identifier = "root"
    #             source_version = "main"
    #         }
            
    #         # True if buildspec is located in source repo 
    #         useBuildspecPath = true
    #         buildspec_path = "apps/product-rest-api/buildspec-dev.yml"
    #         buildspec_yaml = "templates/buildspec.yaml"
    #     }
    # },

    # MzcUser = {
    #     #codepipeline option
    #     CodePipeline = {
    #         Name = "user-rest-api",
    #         FullRepositoryId = "megazone/mzc-user",
    #         BranchName = "main",

    #         #not use below variable
    #         source = "Bitbucket",
    #         config_path = "mzc-user"
    #     },
    #     #approval option
    #     Approval = {
    #         useApprovalStage = false
    #     },         
    #     #codebuild option
    #     CodeBuild = {
    #         artifacts = {
    #             type = "CODEPIPELINE"
    #             path = "codebuild-artifacts"
    #         }
            
    #         cache = {
    #             type = "LOCAL"
    #             modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
    #         }

    #         environment = {
    #             compute_type                = "BUILD_GENERAL1_LARGE"
    #             image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    #             type                        = "LINUX_CONTAINER"
    #             image_pull_credentials_type = "CODEBUILD"
    #             privileged_mode             = true
    #         }  

    #         environment_variables = {
    #             "DOMAIN_NAME"  = { val = "user", type = "PLAINTEXT" },
    #             "GRADLE_ENV"   = { val = "dev", type = "PLAINTEXT" },
    #             "AWS_DEFAULT_REGION"   = { val = "ap-northeast-2", type = "PLAINTEXT" },
    #             "APP_NAME"   = { val = "user-rest-api", type = "PLAINTEXT" },
    #             "CONTAINER_NAME"   = { val = "user-rest-api", type = "PLAINTEXT" },
    #             "DOCKERHUB_USER" = { val = "mzc-cpd-codebuild-docker-hub:username", type = "SECRETS_MANAGER" },
    #             "DOCKERHUB_PASS"    = { val = "mzc-cpd-codebuild-docker-hub:password", type = "SECRETS_MANAGER" },
    #             "BITBUCKET_PASSWORD"    = { val = "devops-bitbucket:password", type = "SECRETS_MANAGER" }
    #         }

    #         secondary_sources = {
    #             type = "BITBUCKET"
    #             source_identifier = "root"
    #             location = "https://leehodong@bitbucket.org/megazone/mzc-kraken"
    #             git_clone_depth = "1"
    #         }

    #         secondary_source_version = {
    #             source_identifier = "root"
    #             source_version = "main"
    #         }
            
    #         # True if buildspec is located in source repo 
    #         useBuildspecPath = true
    #         buildspec_path = "apps/user-rest-api/buildspec-dev.yml"
    #         buildspec_yaml = "templates/buildspec.yaml"
    #     }
    # }
}