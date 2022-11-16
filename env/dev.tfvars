project = "cloudplex"
env = "dev"
prefix = "MzcDevCpp-"
approval_group_name = ""
codestar_connections_arn = ""
aws_codebuild_source_credential_bitbucket_token = ""
codepipeline_bucket_name = ""

pipeline = {
    MzcSpace = {
        #codepipeline option
        CodePipeline = {
            Name = "space-rest-api",
            FullRepositoryId = "megazone/mzc-space",
            BranchName = "main",

            #not use below variable
            source = "Bitbucket",
            config_path = "mzc-space/rest-api"
        },
        #approval option
        Approval = {
            build_approval = false
        }, 
        #codebuild option
        CodeBuild = {
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
                "GRADLE_ENV"   = { val = "dev", type = "PLAINTEXT" },
                "AWS_DEFAULT_REGION"   = { val = "ap-northeast-2", type = "PLAINTEXT" },
                "APP_NAME"   = { val = "space-rest-api", type = "PLAINTEXT" },
                "CONTAINER_NAME"   = { val = "space-rest-api", type = "PLAINTEXT" },
                "DOCKERHUB_USER" = { val = "mzc-cpd-codebuild-docker-hub:username", type = "SECRETS_MANAGER" },
                "DOCKERHUB_PASS"    = { val = "mzc-cpd-codebuild-docker-hub:password", type = "SECRETS_MANAGER" },
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
            
            # True if buildspec is located in source repo 
            useBuildspecPath = false
            buildspec_path = "apps/space-rest-api/buildspec-dev.yml"
            buildspec_yaml = "buildspec.yaml"
        }    
    },

    MzcProduct = {
        #codepipeline option
        CodePipeline = {
            Name = "product-rest-api",
            FullRepositoryId = "megazone/mzc-product",
            BranchName = "main",

            #not use below variable
            source = "Bitbucket",
            config_path = "mzc-product"
        },
        #approval option
        Approval = {
            build_approval = false
        },         
        #codebuild option
        CodeBuild = {
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
                "DOMAIN_NAME"  = { val = "product", type = "PLAINTEXT" },
                "GRADLE_ENV"   = { val = "dev", type = "PLAINTEXT" },
                "AWS_DEFAULT_REGION"   = { val = "ap-northeast-2", type = "PLAINTEXT" },
                "APP_NAME"   = { val = "product-rest-api", type = "PLAINTEXT" },
                "CONTAINER_NAME"   = { val = "product-rest-api", type = "PLAINTEXT" },
                "DOCKERHUB_USER" = { val = "mzc-cpd-codebuild-docker-hub:username", type = "SECRETS_MANAGER" },
                "DOCKERHUB_PASS"    = { val = "mzc-cpd-codebuild-docker-hub:password", type = "SECRETS_MANAGER" },
                "BITBUCKET_PASSWORD"    = { val = "devops-bitbucket:password", type = "SECRETS_MANAGER" }
            }
            
            # True if buildspec is located in source repo 
            useBuildspecPath = true
            buildspec_path = "apps/product-rest-api/buildspec-dev.yml"
            buildspec_yaml = ""
        }
    },

    MzcUser = {
        #codepipeline option
        CodePipeline = {
            Name = "user-rest-api",
            FullRepositoryId = "megazone/mzc-user",
            BranchName = "main",

            #not use below variable
            source = "Bitbucket",
            config_path = "mzc-user"
        },
        #approval option
        Approval = {
            build_approval = false
        },         
        #codebuild option
        CodeBuild = {
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
                "DOMAIN_NAME"  = { val = "user", type = "PLAINTEXT" },
                "GRADLE_ENV"   = { val = "dev", type = "PLAINTEXT" },
                "AWS_DEFAULT_REGION"   = { val = "ap-northeast-2", type = "PLAINTEXT" },
                "APP_NAME"   = { val = "user-rest-api", type = "PLAINTEXT" },
                "CONTAINER_NAME"   = { val = "user-rest-api", type = "PLAINTEXT" },
                "DOCKERHUB_USER" = { val = "mzc-cpd-codebuild-docker-hub:username", type = "SECRETS_MANAGER" },
                "DOCKERHUB_PASS"    = { val = "mzc-cpd-codebuild-docker-hub:password", type = "SECRETS_MANAGER" },
                "BITBUCKET_PASSWORD"    = { val = "devops-bitbucket:password", type = "SECRETS_MANAGER" }
            }

            secondary_sources = {
            }

            secondary_source_version = {
            }
            
            # True if buildspec is located in source repo 
            useBuildspecPath = true
            buildspec_path = "apps/user-rest-api/buildspec-dev.yml"
            buildspec_yaml = ""
        }
    }
}