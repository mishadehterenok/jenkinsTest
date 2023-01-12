#!groovy
pipeline {
    agent {
        node { label 'master' }
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
        timestamps ()
    }
    environment {
        props = readProperties  file: 'backup.properties'
    }
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
                    echo env.props['max.count']
                    echo env.props['job.frequency']
//                 }
            }
        }
    }
}