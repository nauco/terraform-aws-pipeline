project = "cloudplex"
codestar_connections_arn = ""

pipeline = {
    MzcSpace = {
        #codepipeline option
        CodePipeline = {
            name = "space-rest-api",
            source = "Bitbucket",
            FullRepositoryId = "megazone/mzc-space",
            domain_name = "space",
            app_name = "space-rest-api",
            branch = "main",

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
            name = "product-rest-api",
            source = "Bitbucket",
            FullRepositoryId = "megazone/mzc-product",
            domain_name = "product",
            app_name = "product-rest-api",
            branch = "main",

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
            name = "user-rest-api",
            source = "Bitbucket",
            FullRepositoryId = "megazone/mzc-user",
            domain_name = "user",
            app_name = "user-rest-api",
            branch = "main",

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