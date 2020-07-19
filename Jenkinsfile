pipeline {
    agent any
    options {
        ansiColor('xterm')
    }
    parameters {
        string(name: 'DEST_REGION', defaultValue: 'ap-southeast-2', description: 'Destination Region')
    }
    stages {
        stage('Test') {
            steps {
                sh 'packer build -var "region=${DEST_REGION}" packer.json -color=false'
                archiveArtifacts artifacts: 'output/**'
            }
        }
    }
    post {
      always {
          step([$class: "TapPublisher", testResults: "output/tests.tap"])
      }
    }
}