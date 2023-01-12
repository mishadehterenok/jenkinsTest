pipeline {
    agent {
        node { label 'master' }
    }
    triggers {
        cron '* * * * *'
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
    }


    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
    }
}