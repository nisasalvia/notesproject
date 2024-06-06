pipeline {
    agent any 
    
    stages{
        stage("Clone Code"){
            steps {
                echo "Cloning the code"
                git url:"https://github.com/nisasalvia/notesproject.git", branch: "main"
            }
        }
        stage("Build"){
            steps {
                echo "Building the image"
                bat "docker build -t notes-app ."
            }
        }
        stage("Push to Docker Hub"){
            steps {
                echo "Pushing the image to docker hub"
                withCredentials([usernamePassword(credentialsId:"dockerHub",passwordVariable:"dockerHubPass",usernameVariable:"dockerHubUser")]){
                bat "docker tag notes-app ${env.dockerHubUser}/notes-app:latest"
                bat "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}"
                bat "docker push ${env.dockerHubUser}/notes-app:latest"
                }
            }
        }
        stage("Deploy"){
            steps {
                echo "Deploying the container"
                bat "docker-compose down && docker-compose up -d"
                
            }
        }
    }
}