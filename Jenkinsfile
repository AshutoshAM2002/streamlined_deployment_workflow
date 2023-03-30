pipeline{
    agent any
    stages{
        stage("sonar quality check"){
            agent{
                docker {
                    image 'maven'
                    args '-v $HOME/.m2:/root/.m2'
                }
            }
            steps{
                script{
                    withSonarQubeEnv('sonarserver') {
                        sh 'mvn sonar:sonar'
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
}