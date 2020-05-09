node{
    
    stage('SCM CHeckout'){
        
        git credentialsId: 'e892e7e6-2365-4baa-8ed7-5e72eeb96f84', url: 'https://github.com/ShirajGagneja/docker-ci-cd.git'
        
    }
    
    stage('Build Docker Image'){
        
        sh "docker build -t shiraj07/shirajwebapp-php:${BUILD_VERSION} ."
        
    }
    
    stage('Docker Image push to DockerHub'){
        
     withCredentials([string(credentialsId: 'DockerPwds', variable: 'DockerPwd')]) {
       sh "docker login -u shiraj0007 -p ${DockerPwd}"  
     }
        sh "docker push shiraj07/shirajwebapp-php:${BUILD_VERSION}"
    }
    
    
    
    stage('Run Docker Image on Dev') {
        
        sshagent(credentials: ['awskey']) {
            sh "ssh -o StrictHostKeyChecking=no ec2-user@${DEV_SERVER} 'docker run -itd --network shirajnw -p 8090:80 shiraj07/shirajwebapp-php:${BUILD_VERSION}'"
        }
        
    }
    
        stage('Test Deployment on Dev') {
        
        sshagent(credentials: ['awskey']) {
            sh "ssh -o StrictHostKeyChecking=no ec2-user@${DEV_SERVER} 'curl localhost:8090'"
        }
        
    }
    
}
