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
                    dir('App/'){
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
        }
        stage("docker build and docker push"){
            steps{
                script{
                    dir('App/'){
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
        stage('pushing the helm chart to nexus'){
            steps{
                script{
                    dir('kubernetes/'){
                        withCredentials([string(credentialsId: 'nexus_pass', variable: 'nexus_cred')]) {
                            sh '''
                                 helmversion=$( helm show chart helm-charts | grep version | cut -d: -f 2 | tr -d ' ')
                                 tar -czvf myapp-${helmversion}.tgz helm-charts/
                                 curl -u admin:$nexus_cred http://10.0.0.14:8081/repository/helm-charts-hosted/ --upload-file myapp-${helmversion}.tgz -v
                            '''
                        }
                    }
                }
            }
        }
        stage('deploying application on k8s cluster'){
            steps{
                script{
                    kubeconfig(credentialsId: 'kubeconfig', serverUrl: 'https://10.0.0.13:6443') {
                        sh "kubectl get nodes"
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