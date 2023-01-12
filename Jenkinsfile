#!groovy
// def props = null
def nodeProp = null

node {
    nodeProp = readProperties file: 'backup.properties'
}

// def loadProperties() {
// 	checkout scm
// 	props = readProperties  file: 'backup.properties'
// }

pipeline {
    agent {
        node { label 'master' }
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
        timestamps ()
    }
//     environment {
//         pro = readProperties  file: 'backup.properties'
//     }
    triggers {
        pollSCM ('* * * * *')
//         cron ('* * * * *')
        cron (nodeProp["job.frequency"])
    }


    stages {
        stage('Hello') {
            steps {
                script {
                    echo 'Hello World'
//                     loadProperties ()
                    echo nodeProp['max.count']
                    echo nodeProp['job.frequency']
                }
            }
        }
    }
}