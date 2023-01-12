#!groovy
def props = [:]
podTemplate {
    node('master') {
        checkout scm
        props = readProperties  file: 'backup.properties'
    }
}
pipeline {
    agent {
        node { label 'master' }
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
        timestamps ()
    }
//     environment {
//
//     }
    triggers {
        pollSCM ('* * * * *')
//         cron ('* * * * *')
//         cron (${props["job.frequency"]})
    }


    stages {
        stage('Hello') {
            steps {
//                 script {
                    echo 'Hello World'
                    echo props['max.count']
                    echo props['job.frequency']
//                 }
            }
        }
    }
}