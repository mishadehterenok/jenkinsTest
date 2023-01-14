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
        projectName = "Eliflow backend"
        moduleEliflow = "eliflow"

        chatId = "-1001558288364"
        telegramUrl = "https://api.telegram.org/bot1496513691:AAH65fJ_WDVUVst9v3XKlcK4oE7XKRrVnqc/sendMessage"
    }

    stages {
        stage('Hello') {
            steps {
                script {
                    sh 'ls'
                    echo "max.count - ${nodeProp['max.count']}"
                    echo "job.frequency - ${nodeProp['job.frequency']}"
                    echo "timezone - ${nodeProp['timezone']}"
                    echo "frequency - ${frequency}"
                }
            }
        }
    }
}