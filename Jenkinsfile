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
                    withCredentials([sshUserPrivateKey(credentialsId: 'ecdsa-sha2-nistp256', keyFileVariable: 'identity')]) {
                        def remote = [:]
                        remote.user = 'nafisa102003'
                        remote.host = '34.125.180.116'
                        remote.identityFile = identity
                        remote.allowAnyHosts = true
                        sshCommand remote: remote, command: 'ansible-playbook -i inventory deploy.yml'

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
}
