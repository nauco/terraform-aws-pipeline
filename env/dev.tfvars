project = "cloudplex"
prefix = "MzcDevCpp-"
codestar_connections_arn = "arn:aws:codestar-connections:ap-northeast-2:179248873946:connection/a0807f60-eb1c-4f6a-aea6-c9b85977769b"
aws_codebuild_source_credential_bitbucket_token = "5dRjPC36dpubwrZWMRxB"

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
        #codebuild option
        CodeBuild = {
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

            buildspec = "apps/space-rest-api/buildspec-dev.yml"
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
        #codebuild option
        CodeBuild = {
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

            buildspec = "apps/product-rest-api/buildspec-dev.yml"
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
        #codebuild option
        CodeBuild = {
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

            buildspec = "apps/user-rest-api/buildspec-dev.yml"
        }
    }
}