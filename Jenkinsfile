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
                bat "docker build -t notes-app ."
            }
        }
        stage("Push to Docker Hub"){
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPass', usernameVariable: 'dockerHubUser')]) {
                        bat """
                        docker tag notes-app ${env.dockerHubUser}/notes-app:latest
                        docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}
                        docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                        docker push ${env.dockerHubUser}/notes-app:latest
                        docker logout
                        """
                    }
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