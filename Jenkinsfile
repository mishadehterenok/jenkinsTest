#!groovy
def nodeProp = null
def frequency = null
node {
    checkout scm
    nodeProp = readProperties file: 'backup.properties'
    script {
        if (nodeProp['job.frequency'] == 'HOUR') {
            frequency = "0 */1 * * *"
        } else if (nodeProp['job.frequency'] == 'DAY') {
            frequency = "0 0 * * *"
        } else if (nodeProp['job.frequency'] == 'WEEK') {
            frequency = "0 0 */1 * 1"
        } else if (nodeProp['job.frequency'] == 'MONTH') {
            frequency = "0 0 1 */1 *"
        } else {
            error("Invalid frequency: ${nodeProp['job.frequency']}, aborting the build.")
        }
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
    triggers {
        cron """TZ=${nodeProp["timezone"]}
                ${frequency}"""
    }
    environment {
        dockerContainer = "eliflow_mongodb"

        chatId = "-1001558288364"
        telegramUrl = "https://api.telegram.org/bot1496513691:AAH65fJ_WDVUVst9v3XKlcK4oE7XKRrVnqc/sendMessage"
    }

    stages {
        stage('Info') {
            steps {
                script {
                    echo """
                    _______INFO_______
                    max.count - ${nodeProp['max.count']}
                    job.frequency - ${nodeProp['job.frequency']}
                    timezone - ${nodeProp['timezone']}
                    frequency - ${frequency}
                    """
                    env.buildStartMessage = "${env.dockerContainer} CI/CD backup creation job started #${env.BUILD_NUMBER}"
                    env.buildFinalMessage = "${env.dockerContainer} CI/CD backup creation job finished #${env.BUILD_NUMBER}"
                }
            }
        }
//         stage("Pipeline Start Notification") {
//             steps {
//                 sh """
//                     curl -X POST -H 'Content-Type: application/json' \\
//                     -d '{"chat_id": "${env.chatId}", "text": "${env.buildStartMessage}","disable_notification": false}' \\
//                     ${env.telegramUrl}
//                    """
//             }
//         }
        stage("Backup creation") {
            environment {
                grepRunningContainer = "docker ps --format '{{.Names}}' | grep ${env.dockerContainer}"
            }
            steps {
                script {
                    echo "________BACKUP ACTION________"
                    if (sh(script: "${env.grepRunningContainer}", returnStatus: true) == 0) {
                        echo "Proceeding with running database container: ${env.dockerContainer}"
                        sh """
                            docker cp ./create_backup.sh ${env.dockerContainer}:/opt/
                            docker exec -u 0 -i ${env.dockerContainer} bash /opt/create_backup.sh ${nodeProp['max.count']}
                           """
                    }
                    else {
                        error("No working containers found with name '${env.dockerContainer}', aborting the build.")
                }
            }
        }
    }
    post {
        always {
            script {
                String resultMessage = "${env.buildFinalMessage} - ${currentBuild.currentResult}"
//                     sh """
//                         curl -X POST -H 'Content-Type: application/json' \\
//                         -d '{"chat_id": "${env.chatId}", "text": "${resultMessage}", "disable_notification": false}' \\
//                         ${env.telegramUrl}
//                        """
            }
        }
    }
}