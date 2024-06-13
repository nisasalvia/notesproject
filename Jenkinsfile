pipeline {
    agent any 
    
    stages{
        stage("Clone Code"){
            steps {
                echo "Cloning the code"
                git url:"https://github.com/nisasalvia/notesproject.git", branch: "master"
            }
        }
        stage("Build"){
            steps {
                echo "Building the image"
                // bat "docker build -t notes-app ."
                script {
                    dockerImage = docker.build("notes-app", "--network host .")
                }
            }
        }
        stage("Push to Docker Hub"){
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPass', usernameVariable: 'dockerHubUser')]) {
                        bat """
                        docker tag notes-app ${env.dockerHubUser}/notes-app:latest
                        docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}
                        docker push ${env.dockerHubUser}/notes-app:latest
                        docker logout
                        """
                    }
                }
            }
        }
        stage("Deploy to GCP") {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'ssh-rsa', keyFileVariable: 'identity', passphraseVariable: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAFsgWV2NMCEEHzqZcaGqdiT8LSsWy/iY9IEeJ9k/jOvX+pofRdeXDrYxvQFGbQ/0/eb/UKjuPySrA7SeLHrA23zMDyPN3pGEDA/qeH3GgXPrN23R+rKYp3ejyuWqkt4QzOvxBAh2puXxhhTlvrqeAoybVLwuSMMawbVJlUjyBz5P5tCwc0bkoHPIxBkJZ/ADtXuIh5jX5PXUfL3lGXAOWzTyCtilHvwUtp1zjCjp+uYGoSuV87EkTqUytiQjyyXWgk6BCwPL2JPEUZYC/7xpin72dbUka7Gu+1+gr8E4pGkxo0vC/5s9jecLn4J8dXacQhUNMUxA8AhhuP9D+wNFY/orxg6TJwCX2GiuoJz8ycUrpQv1creknGjbAvxhUIP3dfWgpJh8pGNLH/RQ9f6srWj9M2gS0kmIWrwXOWwGyll2N+yERaywygz4UvD1qOxhEhNreU3TNnqY1PBlIoe+AwxXlBCZy2Bzs6nBfSBdgLhbJjtb3Z2p5hjuoi9bs0EKyMR7gbkGZJwjYz6Xy6/x3/QmUwJkzUfKI1qpkxF8N2b8HTgtfJnNbkAge8kql+xiP8NTbkAyXkuSV9ukLfyqDFUGwSYgbg/cnMLzqMdXZ2nhMKNQP7Yh5S0/goMq5vJGOFNRIWdTortIGJsXs2PVwQB0N97GDBJyZrz1GKvhGFQ==')]) {
                        bat """
                        @echo off
                        setlocal enabledelayedexpansion

                        REM Transfer inventory and deploy.yml using scp
                        scp -i %IDENTITY% -o StrictHostKeyChecking=no inventory nafisa102003@34.19.111.242:~/
                        scp -i %IDENTITY% -o StrictHostKeyChecking=no deploy.yml nafisa102003@34.19.111.242:~/

                        REM Execute ansible-playbook using ssh
                        ssh -i %IDENTITY% -o StrictHostKeyChecking=no nafisa102003@34.19.111.242 "ansible-playbook -i ~/inventory ~/deploy.yml"
                        """
                        // set IDENTITY=%identity%
                        // pscp -batch -i %IDENTITY% -r inventory nafisa102003@34.19.111.242:~/
                        // pscp -batch -i %IDENTITY% -r deploy.yml nafisa102003@34.125.180.116:~/
                        // plink -batch -i %IDENTITY% nafisa102003@34.125.180.116 "ansible-playbook -i ~/inventory ~/deploy.yml"
                        // """
                    }

                    // withCredentials([sshUserPrivateKey(credentialsId: 'ecdsa-sha2-nistp256', keyFileVariable: 'identity')]) {
                    //     sh """
                    //     scp -o StrictHostKeyChecking=no -i $identity inventory deploy.yml nafisa102003@34.125.180.116:~
                    //     ssh -o StrictHostKeyChecking=no -i $identity nafisa102003@34.125.180.116 '
                    //     ansible-playbook -i ~/inventory ~/deploy.yml'
                    //     """
                    // bat 'ansible-playbook -i inventory deploy.yml'
                }
            }
        }
    }
}
