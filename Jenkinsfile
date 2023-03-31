pipeline{
    agent any
    environment {
        DOCKERHUB_CREDENTIALS=credentials('dockerhub-cred')
//        VERSION = "\$(env.BUILD_ID)"
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
    post {
		always {
            emailext body: '', recipientProviders: [developers()], subject: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS!', to: 'ashutoshmahajan2002@gmail.com'
        }
    }
    }
}