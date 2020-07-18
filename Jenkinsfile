pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
                sh 'env'
                sh 'echo "1..2" >> tests.tap'
                sh 'echo "ok 1 - ngnix okay" >> tests.tap'
                sh 'echo "ok 2 - certifcate happy" >> tests.tap'
            }
        }
    }
    post {
      always {
          step([$class: "TapPublisher", testResults: "tests.tap"])
      }
    }
}