#!groovy
def nodeProp = null
def frequency = null
node {
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
        branch_name = "dev"

        chatId = "-1001558288364"
        telegramUrl = "https://api.telegram.org/bot1496513691:AAH65fJ_WDVUVst9v3XKlcK4oE7XKRrVnqc/sendMessage"

        stateFile = "state.log"
//         PATH="/usr/local/bin/docker-compose"
    }

    stages {
        stage('Hello') {
            steps {
                script {
                    sh 'ls'
                    sh 'pwd'
                    sh 'docker compose version'
                    echo """
                    env.branch_name - ${env.branch_name}
                    max.count - ${nodeProp['max.count']}
                    job.frequency - ${nodeProp['job.frequency']}
                    timezone - ${nodeProp['timezone']}
                    frequency - ${frequency}
                    """
                    env.buildStartMessage = "${env.project} CI/CD #${env.BRANCH_NAME} backup creation job started #${env.BUILD_NUMBER}"
                    env.buildFinalMessage = "${env.project} CI/CD #${env.BRANCH_NAME} backup creation job finished #${env.BUILD_NUMBER}"
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

        stage('Git clone') {
            steps {
                sh "rm -rf ${env.project}"
                sh "git clone --progress https://ayurkov:perpentum@gitlab.elinext.com/eliflow/backend-new.git ${env.project}"
                dir ("${env.project}") {
                sh "git checkout ${env.branch_name}"
                }
            }
            post {
                failure {
                    sh "echo 'FAILED TO CLONE REPOSITORY' > ${env.stateFile}"
                }
            }
        }
        stage("Run database container") {
            environment {
                dockerContainer = "eliflow_mongodb"
                grepOldContainers = "docker ps -a --format '{{.Names}}' | grep mongodb"
                grepRunningContainer = "docker ps --format '{{.Names}}' | grep ${dockerContainer}"
            }
            steps {
                script {
                    if (sh(script: "${env.grepRunningContainer}", returnStatus: true) == 0) {
                        echo "Proceeding with existing running database container: ${env.dockerContainer}"
                        sh "docker ps"
                    }
                    else {
                    sh "docker ps"
                    echo "${PATH}"
                        echo "No working containers found with name: ${env.dockerContainer}"
                        String[] containers = []
                        def statusCode = sh(script: "${env.grepOldContainers}", returnStatus: true)

                        if (statusCode == 0) {
                            containers = sh(script: "${env.grepOldContainers}", returnStdout: true).split("\n")
                        }
                        echo "Available old containers: $containers"

                        if (containers.length > 0 && !containers[0].isEmpty()) {
                            echo "Removing old containers"
                            sh "docker rm -f \$(${env.grepOldContainers})"
                        }
                        echo "Starting up new container"
                        sh "docker-compose up -d mongodb"
                        sleep(60)
                        def isContainerRunning = sh(script: "docker container inspect -f '{{.State.Running}}' ${env.dockerContainer}", returnStdout: true).trim()

                        if (isContainerRunning == 'false') {
                            sh "docker logs ${env.dockerContainer} > ${env.dockerContainer}.log"
                            archiveArtifacts "${env.dockerContainer}.log"
                            error "Docker container stopped. See logs in artifacts."
                        }
                    }
                }
            }
            post {
                failure {
                    sh "echo 'FAILED TO RUN DATABASE CONTAINER' > ${env.stateFile}"
                }
            }
        }
        stage("Backup creation") {
            steps {
                script {
                    echo "=================BACKUP ACTION========================"
//                     sh """
//                     docker cp ./mongo/scripts eliflow_mongodb:/opt/eliflow_scripts/
//                     docker exec -u 0 -it eliflow_mongodb bash /opt/eliflow_scripts/create_backup.sh ${nodeProp['max.count']}
//                     """
                }
            }
            post {
                failure {
                    sh "echo 'FAILED TO CREATE BACKUP' > ${env.stateFile}"
                }
                success {
                    sh "echo 'SUCCESS' > ${env.stateFile}"
                }
            }
        }
    }
    post {
        always {
            script {
                def state = readFile(file: "${env.stateFile}").trim().replace("\n", "")

                String resultMessage = "${env.buildFinalMessage} - ${state}"
                echo "______Status:______"
                echo "${resultMessage}"
//                     sh """
//                         curl -X POST -H 'Content-Type: application/json' \\
//                         -d '{"chat_id": "${env.chatId}", "text": "${deployMessage}", "disable_notification": false}' \\
//                         ${env.telegramUrl}
//                        """
            }
//             cleanWs()
//             dir("${env.WORKSPACE}") {
//                 deleteDir()
//             }
//             dir("${env.WORKSPACE}@tmp") {
//                 deleteDir()
//             }
        }
    }
}