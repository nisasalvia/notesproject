pipeline {
    agent any 
    
    environment {
        // Set AWS credentials using Jenkins credentials manager
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        // Set the Terraform path
        TERRAFORM_PATH = 'C:\terraform'
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
                // withCredentials([usernamePassword(credentialsId:"dockerhub-login",passwordVariable:"admin1234",usernameVariable:"nisasalvia" )]){
                //     bat "docker tag notes-app ${env.nisasalvia}/notesproject:latest"
                //     bat "docker login -u ${env.nisasalvia} -p ${env.admin1234}"
                //     bat "docker push ${env.nisasalvia}/notesproject:latest"
                // }
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
        // stage("Retrieve Public IP") {
        //     steps {
        //         script {
        //             def publicIp = bat(script: "%TERRAFORM_PATH% output -raw public_ip", returnStdout: true).trim()
        //             echo "Public IP: ${publicIp}"
        //         }
        //     }
        // }
        stage("Deployment") {
            steps {
                echo 'Deploying container'
                bat 'docker-compose down --timeout 30 && docker-compose up -d'                
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
