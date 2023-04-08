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
//            steps{
//                script{
//                    sh '''
//                    docker build -t ashutosham2002/java-spring-boot-app:$BUILD_ID --build-arg BUILD_ID=$BUILD_ID .
//                    echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
//                    docker push ashutosham2002/java-spring-boot-app:$BUILD_ID
//                    docker rmi ashutosham2002/java-spring-boot-app:$BUILD_ID
//                    '''
//                }
//            }
              steps{
                 script{
                    def dockerfileHash = sh(returnStdout: true, script: "md5sum Dockerfile | cut -d ' ' -f1").trim()
                    def sourceCodeHash = sh(returnStdout: true, script: "find . -type f -name '*.java' | sort | xargs cat | md5sum | cut -d ' ' -f1").trim()
                    def lastImageHash = sh(returnStdout: true, script: "docker inspect --format='{{.Id}}' ashutosham2002/java-spring-boot-app:$BUILD_ID || echo 'notfound'").trim()

                    if (dockerfileHash == lastImageHash && sourceCodeHash == lastImageHash) {
                        echo "Skipping Docker image push because there are no changes."
                    } else {
                        sh '''
                        docker build -t ashutosham2002/java-spring-boot-app:$BUILD_ID --build-arg BUILD_ID=$BUILD_ID .
                        echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                        docker push ashutosham2002/java-spring-boot-app:$BUILD_ID
                        docker rmi ashutosham2002/java-spring-boot-app:$BUILD_ID
                        '''
                    }
                 }
              }
        }
        stage('identifying misconfig using datree in helm charts'){
            steps{
                script{
                    dir('kubernetes/'){
                        withEnv(['DATREE_TOKEN=e24c894e-68c8-405b-9551-e4dfbea829bd']){
                            sh 'helm datree test helm-charts/'

                        }
                        
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