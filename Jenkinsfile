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
    
    
    stage('Run Docker Image on Dev') {
        input "Deploy to prod?"
        sshagent(credentials: ['awskey']) {
            sh "ssh -o StrictHostKeyChecking=no ec2-user@${DEV_SERVER} 'docker rm -f web_app ; docker run -itd --network shirajnw --name web_app -p 8090:80 shiraj07/shirajwebapp-php:${BUILD_VERSION}'"
        }
        
    }
    
    stage('Test Deployment on Dev') {
        
        sshagent(credentials: ['awskey']) {
            sh "ssh -o StrictHostKeyChecking=no ec2-user@${DEV_SERVER} 'curl localhost:8090'"
        }
        
    }
    
    stage('Make Step Fail') {
        
        sshagent(credentials: ['awskey']) {
            catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                sh "exit 1"
            }
        }
        
    }
    
    stage('Test Deployment - 2 on Dev') {
        
        sshagent(credentials: ['awskey']) {
            sh "ssh -o StrictHostKeyChecking=no ec2-user@${DEV_SERVER} 'docker inspect web_app'"
        }
        
    }
	
	stage('Parallel Tests as Steps') {
        def steps = [:]
        steps["Curl Test"] = {
                sshagent(credentials: ['awskey']) {
                sh "ssh -o StrictHostKeyChecking=no ec2-user@${DEV_SERVER} 'curl localhost:8090'"
            }
        }
        steps["Make Test Fail"] = {
                sshagent(credentials: ['awskey']) {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    sh "exit 1"
                }
            }
        }
        steps["Inspect Test"] = {
                sshagent(credentials: ['awskey']) {
                sh "ssh -o StrictHostKeyChecking=no ec2-user@${DEV_SERVER} 'docker inspect web_app'"
            }
        }
        parallel steps
    }
    
	parallel (
		'ConditionalTest': {
            // parameters {
            //     string(name: 'custom_var', defaultValue: 'true', description:'condition check in stage')
            //     string(name: 'custom_var_stage_check', defaultValue: 'true', description:'check stage skip')
            // }

            execute_next_stage = true
            execute_if_in_next_stage = true

            try{
                stage('Parallel Stage Test1 : Curl Test') {
                        sshagent(credentials: ['awskey']) {
                        def curlOutput = sh "ssh -o StrictHostKeyChecking=no ec2-user@${DEV_SERVER} 'curl localhost:8090'"
                        if (currentBuild.resultIsBetterOrEqualTo('SUCCESS')) {
                            execute_next_stage = false
                            // echo "Previous build failed ${currentBuild?.getPreviousBuild()?.number} and now it has been fixed"
                        }
                    }
			    }
            }
            catch(Exception  e) {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    sh "exit 1"
                }
            }

			if(execute_next_stage){
                stage('Parallel Stage Test2 : Inspect Test or Make Fail') {
			
                    if(execute_if_in_next_stage){
                            sshagent(credentials: ['awskey']) {
                            sh "ssh -o StrictHostKeyChecking=no ec2-user@${DEV_SERVER} 'docker inspect web_app'"
                        }
                    }
                    else{
                            catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                            sh "exit 1"
                        }
                    }
			    }
            }
		},
		'ShouldFailTest': {
            stage('Parallel Stage Test3 : Test Fail') {
            catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    sh "exit 1"
                }
			}
		}
	)
}
