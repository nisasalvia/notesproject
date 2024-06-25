pipeline {
    agent any 
    
    environment {
        // Set AWS credentials using Jenkins credentials manager
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        // Set the Terraform path
        // TERRAFORM_PATH = '/var/lib/jenkins/workspace/notesproject/terraform'
        EC2_INSTANCE = 'ec2-user@46.137.194.170'
        SSH_KEY = 'ssh_key' // The ID of the SSH key stored in Jenkins credentials
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
                    withCredentials([usernamePassword(credentialsId:"dockerHub",passwordVariable:"admin1234",usernameVariable:"nisasalvia" )]){
                        sh "docker tag notes-app ${env.nisasalvia}/notes-app:latest"
                        sh "docker login -u ${env.nisasalvia} -p ${env.admin1234}"
                        sh "docker push ${env.nisasalvia}/notes-app:latest"
                    }
                   
                    // withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'admin1234', usernameVariable: 'nisasalvia')]) {
                    //     bat """
                    //     docker tag notes-app ${env.nisasalvia}/notes-app:latest
                    //     docker login -u ${env.nisa} -p ${env.dockerHubPass}
                    //     docker push ${env.dockerHubUser}/notes-app:latest
                    //     docker logout
                    //     """
                    // }
                }
            }
        }

        stage("Terraform Init") {
            steps {
                echo 'Initializing Terraform'
                sh 'terraform init'
                // sh "${TERRAFORM_PATH} init"
                    // sh """
                    // ssh -i ${keyfile} ${EC2_INSTANCE} << EOF
                    // cd /home/ubuntu/notes-app-aws
                    // terraform init
                    // EOF
                    // """
            }

        }

        stage("Terraform Plan") {
            steps {
                echo 'Planning Terraform changes'
                sh 'terraform plan -out=tfplan -parallelism=10'
                // sh "${TERRAFORM_PATH} plan -out=tfplan"
                    // sh """
                    // ssh -i ${keyfile} ${EC2_INSTANCE} << EOF
                    // cd /home/ubuntu/notes-app-aws
                    // terraform plan -out=tfplan
                    // EOF
                    // ""
            }
        }

        stage("Terraform Apply") {
            steps {
                echo 'Applying Terraform changes'
                sh 'terraform apply -auto-approve tfplan'
                // sh "${TERRAFORM_PATH} apply -auto-approve tfplan"
                    // sh """
                    // ssh -i ${keyfile} ${EC2_INSTANCE} << EOF
                    // cd /home/ubuntu/notes-app-aws
                    // terraform apply -auto-approve tfplan
                    // EOF
                    // """
            }
                
        }
        
        stage("Deployment") {
            steps {
                // echo 'Deploying container'
                // sh 'docker-compose down --timeout 30 && docker-compose up -d'                
                echo 'Deploying to EC2'
                withCredentials([sshUserPrivateKey(credentialsId: 'ssh_key', keyFileVariable: 'keyfile')]) {
                    script {
                        //Transfer Docker Compose file to EC2 instance
                        sh "scp -i ${keyfile} docker-compose.yml ${EC2_INSTANCE}:~/"
                        //SSH into EC2 instance and run Docker commands
                        sh """
                        ssh -i ${keyfile} ${EC2_INSTANCE} << EOF
                        docker-compose down --timeout 30
                        docker-compose pull ${env.nisasalvia}/notes-app:latest
                        docker-compose up -d
                        EOF
                        """
                    }
                }
            }
        }
    }
    post {
        always {
            echo 'Cleaning up'
            sh 'rm -f tfplan'
        }
        success {
            echo 'Pipeline succeeded'
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}
