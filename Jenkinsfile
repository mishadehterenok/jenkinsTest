#!groovy
def props = [:]
pipeline {
    agent {
        node {
            label 'master'
            checkout scm
            props = readProperties  file: 'backup.properties'
         }
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
                    echo "${env.props['max.count']}"
//                     echo env.props['job.frequency']
//                 }
            }
        }
    }
}