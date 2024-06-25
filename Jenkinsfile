pipeline {
    agent any 
    
    environment {
        // Set AWS credentials using Jenkins credentials manager
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        // Set the Terraform path
        TERRAFORM_PATH = 'C:\terraform\terraform.exe'
        EC2_INSTANCE = 'ec2-user@172.31.29.241'
        SSH_KEY = 'SSH_KEY' // The ID of the SSH key stored in Jenkins credentials
    }

    stages{
        stage("Clone Code"){
            steps {
                echo "Cloning the code"
                git url:"https://github.com/nisasalvia/notesproject.git", branch: "master"
            }
        }
        stage("Build") {
            steps {
                // echo "Building the image"
                // bat "docker build -t notes-app ."
                script {
                    dockerImage = docker.build("notes-app", "--network host .")
                }
            }
        }
        stage("Push to Docker Hub"){
            steps {
                script {
                    echo 'This is Test stage'                   
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

        stage("Terraform Init") {
            steps {
                echo 'Initializing Terraform'
                bat "%TERRAFORM_PATH% init"
            }
        }

        stage("Terraform Plan") {
            steps {
                echo 'Planning Terraform changes'
                bat "%TERRAFORM_PATH% plan -out=tfplan"
            }
        }

        stage("Terraform Apply") {
            steps {
                echo 'Applying Terraform changes'
                bat "%TERRAFORM_PATH% apply -auto-approve tfplan"
            }
        }
        
        stage("Deployment") {
            steps {
                // echo 'Deploying container'
                // bat 'docker-compose down --timeout 30 && docker-compose up -d'                
                echo 'Deploying to EC2'
                withCredentials([sshUserPrivateKey(credentialsId: 'SSH_KEY', keyFileVariable: 'keyfile')]) {
                    // Transfer Docker Compose file to EC2 instance
                    bat "scp -i ${keyfile} docker-compose.yml ${EC2_INSTANCE}:~/"

                    // SSH into EC2 instance and run Docker commands
                    bat """
                    ssh -i ${keyfile} ${EC2_INSTANCE} << EOF
                    docker-compose down --timeout 30
                    docker-compose pull ${env.dockerHubUser}/notes-app:latest
                    docker-compose up -d
                    EOF
                    """
                }
            }
        }
    }
    post {
        always {
            echo 'Cleaning up'
            bat 'del -f tfplan'
        }
        success {
            echo 'Pipeline succeeded'
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}
