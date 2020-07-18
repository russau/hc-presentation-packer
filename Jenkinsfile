pipeline {
    agent any
    parameters {
        string(name: 'DEST_REGION', defaultValue: 'ap-southeast-2', description: 'Destination Region')
    }
    stages {
        stage('Test') {
            steps {
                sh 'mkdir output || true'
                sh 'echo "1..2" > output/tests.tap'
                sh 'echo "ok 1 - ngnix okay" >> output/tests.tap'
                sh 'echo "ok 2 - certificate happy" >> output/tests.tap'
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