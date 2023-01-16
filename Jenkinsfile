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
        project = "eliflow-backend"

        chatId = "-1001558288364"
        telegramUrl = "https://api.telegram.org/bot1496513691:AAH65fJ_WDVUVst9v3XKlcK4oE7XKRrVnqc/sendMessage"
    }

    stages {
        stage('Info') {
            steps {
                script {
                    echo """
                    max.count - ${nodeProp['max.count']}
                    job.frequency - ${nodeProp['job.frequency']}
                    timezone - ${nodeProp['timezone']}
                    frequency - ${frequency}
                    """
                    env.buildStartMessage = "${env.project} CI/CD backup creation job started #${env.BUILD_NUMBER}"
                    env.buildFinalMessage = "${env.project} CI/CD backup creation job finished #${env.BUILD_NUMBER}"
                }
            }
        }
        stage("Pipeline Start Notification") {
            steps {
                echo "${env.buildStartMessage}"
//                 sh """
//                     curl -X POST -H 'Content-Type: application/json' \\
//                     -d '{"chat_id": "${env.chatId}", "text": "${env.buildStartMessage}","disable_notification": false}' \\
//                     ${env.telegramUrl}
//                    """
            }
        }
        stage("Backup creation") {
            environment {
                dockerContainer = "eliflow_mongodb"
                grepOldContainers = "docker ps -a --format '{{.Names}}' | grep mongodb"
                grepRunningContainer = "docker ps --format '{{.Names}}' | grep ${dockerContainer}"
            }
            steps {
                script {
                    echo "=================BACKUP ACTION========================"
                    sh """
                        docker cp ./create_backup.sh eliflow_mongodb:/opt/
                        docker exec -u 0 -i eliflow_mongodb bash /opt/create_backup.sh ${nodeProp['max.count']}
                       """
                }
            }
            post {
                failure {
                script{
                env.status="FAIL"
                }
//                     sh "echo 'FAILED TO CREATE BACKUP' > ${env.stateFile}"
                }
                success {
                script{
                                env.status="SUCCESS"
                                }
//                     sh "echo 'SUCCESS' > ${env.stateFile}"
                }
            }
        }
    }
    post {
        always {
            script {
//                 def state = readFile(file: "${env.stateFile}").trim().replace("\n", "")
                String resultMessage = "${env.buildFinalMessage} - ${env.state}"
                echo "______Status:______"
                echo "${resultMessage}"
//                     sh """
//                         curl -X POST -H 'Content-Type: application/json' \\
//                         -d '{"chat_id": "${env.chatId}", "text": "${resultMessage}", "disable_notification": false}' \\
//                         ${env.telegramUrl}
//                        """
            }
        }
    }
}
