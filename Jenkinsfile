pipeline {
    agent any

    stages {
        stage('Clone Code') {
            steps {
                echo 'Cloning the code'
                 git url:"https://github.com/nisasalvia/notesproject.git", branch: "master"
            }
        }
        stage('Build') {
            steps {
                echo 'This is Build Stage'
                sh "docker build -t notes-app ."
            }
        }
        stage('Push to Docker hub') {
            steps {
                echo 'This is Test stage'
                withCredentials([usernamePassword(credentialsId:"dockerHub",passwordVariable:"admin1234",usernameVariable:"nisasalvia" )]){
                    sh "docker tag notes-app ${env.nisasalvia}/notesproject:latest"
                    sh "docker login -u ${env.nisasalvia} -p ${env.admin1234}"
                    sh "docker push ${env.nisasalvia}/notesproject:latest"
                }
        
            }
        }
        stage('Deployement') {
            steps {
                echo 'Deploying container'
                sh 'docker-compose down --timeout 30 && docker-compose up -d'
            }
        }
    }
}