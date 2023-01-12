#!groovy
pipeline {
    agent {
        node {
            label 'master'
//             checkout scm
//             props = readProperties(file:backup.properties)

        }
    }

    triggers {
        pollSCM ('* * * * *')
//         cron ('* * * * *')
//         cron (${props["job.frequency"]})
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
        timestamps ()
    }

    stages {
        stage('Hello') {
            steps {
                script {
                    props = readProperties  file: 'backup.properties'
                    echo 'Hello World'
                    sh "echo $props['max.count']"
//                     echo $props['max.count']
//                     echo "job.frequency -- ${props.job.frequency}"
//                     echo "max.count -- ${props.max.count}"
                }
            }
        }
    }
}