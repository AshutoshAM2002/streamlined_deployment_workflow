pipeline{
    agent any
    environment {
        DOCKERHUB_CREDENTIALS=credentials('dockerhub-cred')
    }
    stages{
        stage("sonar quality check"){
            agent{
                docker {
                    image 'maven:3.6.3'
                    args '-v $HOME/.m2:/root/.m2'
                }
            }
            steps{
                script{
                    withSonarQubeEnv('sonarserver') {
                        sh 'mvn compile sonar:sonar'
                    }
                        timeout(time: 1, unit: 'HOURS'){
                        def qg = waitForQualityGate()
                            if (qg.status != 'OK'){
                                error "pipeline aborted due to quality gate failure: ${qg.status}"
                            }
                        }
                            sh "mvn clean install"
                }
            }
        }
        stage("docker build and docker push"){
            steps{
                script{
                    sh '''
                    docker build -t ashutosham2002/java-spring-boot-app:$BUILD_ID --build-arg BUILD_ID=$BUILD_ID .
                    echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                    docker push ashutosham2002/java-spring-boot-app:$BUILD_ID
                    docker rmi ashutosham2002/java-spring-boot-app:$BUILD_ID
                    '''
                }
            }
        }
        stage('identifying misconfig using datree in helm charts'){
            steps{
                script{
                    dir('kubernetes/'){
                        sh 'helm plugin uninstall datree'
                    }
                }
            }
        }
    }
    post {
		always {
            mail bcc: '', body: "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", to: 'ashutoshmahajan2604@gmail.com';
        }
    }
}