#!groovy
def nodeProp = null

node {
    nodeProp = readProperties file: 'backup.properties'
}

pipeline {
    agent {
        node { label 'master' }
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
        timestamps ()
    }
    triggers {
        pollSCM ('* * * * *')
        cron (nodeProp["job.frequency"])
    }
    stages {
        stage('Hello') {
            steps {
                script {
                    echo 'Hello World'
                    echo nodeProp['max.count']
                    echo nodeProp['job.frequency']
                }
            }
        }
    }
}