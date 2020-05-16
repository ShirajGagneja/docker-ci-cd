node{
    
    stage('SCM CHeckout'){
        
        git credentialsId: 'gitLogin', url: 'https://github.com/ShirajGagneja/docker-ci-cd'
        
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
    
    
}
