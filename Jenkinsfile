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
            def props = readProperties  file: 'backup.properties'
            def Var1 = props['job.frequency']
            def Var2 = props['max.count']
                echo 'Hello World'
                echo "Var1=${Var1}"
                echo "Var2=${Var2}"
            }
        }
    }
}