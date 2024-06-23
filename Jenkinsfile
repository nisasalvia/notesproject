pipeline {
    agent any 
    
    stages{
        stage("Clone Code"){
            steps {
                echo "Cloning the code"
                git url:"https://github.com/nisasalvia/notesproject.git", branch: "master"
            }
        }
        stage("Build") {
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
       stage("Deploy to AWS") {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'ssh-ec2', keyFileVariable: 'identity')]) {
                       // Debug step to check connectivity
                        bat """
                        @echo off
                        REM Testing SSH connectivity to EC2 instance
                        ssh -i %identity% -o StrictHostKeyChecking=no ec2-user@ec2-47-129-46-47.ap-southeast-1.compute.amazonaws.com "echo Connected successfully"
                        
                        REM Transfer inventory and deploy.yml using scp
                        scp -i %identity% -o StrictHostKeyChecking=no inventory ec2-user@ec2-47-129-46-47.ap-southeast-1.compute.amazonaws.com:~/
                        scp -i %identity% -o StrictHostKeyChecking=no deploy.yml ec2-user@ec2-47-129-46-47.ap-southeast-1.compute.amazonaws.com:~/

                        REM Execute ansible-playbook using ssh
                        ssh -i %identity% -o StrictHostKeyChecking=no ec2-user@ec2-47-129-46-47.ap-southeast-1.compute.amazonaws.com "ansible-playbook -i ~/inventory ~/deploy.yml"
                        """
                        
                        // bat """
                        // # Transfer inventory and deploy.yml using scp
                        // scp -i ${identity} -o StrictHostKeyChecking=no inventory ec2-user@47.129.46.47:~/
                        // scp -i ${identity} -o StrictHostKeyChecking=no deploy.yml ec2-user@47.129.46.47:~/

                        // # Execute ansible-playbook using ssh
                        // ssh -i ${identity} -o StrictHostKeyChecking=no ec2-user@47.129.46.47 "ansible-playbook -i ~/inventory ~/deploy.yml"
                        // """
                        // // set IDENTITY=%identity%
                        // // pscp -batch -i %IDENTITY% -r inventory nafisa102003@34.19.111.242:~/
                        // // pscp -batch -i %IDENTITY% -r deploy.yml nafisa102003@34.125.180.116:~/
                        // // plink -batch -i %IDENTITY% nafisa102003@34.125.180.116 "ansible-playbook -i ~/inventory ~/deploy.yml"
                        // // """
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
