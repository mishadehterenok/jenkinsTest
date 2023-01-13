#!groovy
def nodeProp = null
def frequency = null
node {
    nodeProp = readProperties file: 'backup.properties'
//     script {
//         if (nodeProp['job.frequency'] == 'HOUR') {
//             frequency = "0 */1 * * *"
//         }
//         if (nodeProp['job.frequency'] == 'DAY') {
//             frequency = "0 0 * * *"
//         }
//         if (nodeProp['job.frequency'] == 'WEEK') {
//             frequency = "0 0 */1 * 1"
//         }
//         if (nodeProp['job.frequency'] == 'MONTH') {
//             frequency = "0 0 1 */1 *"
//         } else {
//         echo nodeProp['job.frequency']
//             error("Invalid frequency: ${nodeProp['job.frequency']}, aborting the build.") }
//     }
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
//         pollSCM ('* * * * *')
//         cron (nodeProp["job.frequency"])
        cron '''TZ=Europe/Minsk
                ${frequency}'''
    }
    stages {
        stage('Hello') {
            steps {
                script {
                    echo 'Hello World'
                    echo nodeProp['max.count']
                    echo nodeProp['job.frequency']
                    echo nodeProp['timezone']
                    echo ${frequency}
                }
            }
        }
    }
}