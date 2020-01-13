pipeline {
    agent any

    environment {
        HAB_AUTH_TOKEN = credentials('hab-depot-token')
        HAB_BLDR_URL = "https://bldr.habitat.sh"
    }

    stages {
        stage('download-keys') {
            steps {
                sh "hab origin key download ${env.HAB_ORIGIN} --auth ${HAB_AUTH_TOKEN} --url ${env.HAB_BLDR_URL}"
                sh "hab origin key download ${env.HAB_ORIGIN} --auth ${HAB_AUTH_TOKEN} --url ${env.HAB_BLDR_URL} --secret"
            }
        }
        stage('build') {
            steps {
                dir("${workspace}") {
                    habitat task: 'build', directory: '.', origin: env.HAB_ORIGIN, authToken: env.HAB_AUTH_TOKEN, bldrUrl: env.HAB_BLDR_URL
                }
            }
        }
        stage('upload') {
            steps {
                habitat task: 'upload', lastBuildFile: "${workspace}/results/last_build.env", authToken: env.HAB_AUTH_TOKEN, bldrUrl: env.HAB_BLDR_URL
            }
        }
        stage('promote') {
            when { equals expected: 'master', actual: env.BRANCH_NAME }
            steps {
                habitat task: 'promote', channel: 'stage', lastBuildFile: "${workspace}/results/last_build.env", authToken: env.HAB_AUTH_TOKEN, bldrUrl: env.HAB_BLDR_URL
            }
        }
    }
}
