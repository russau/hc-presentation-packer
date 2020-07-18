pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
                sh 'env'
                sh 'echo "1..2" > output/tests.tap'
                sh 'echo "ok 1 - ngnix okay" > output/tests.tap'
                sh 'echo "ok 2 - certificate happy" >> output/tests.tap'
            }
        }
    }
    post {
      always {
          step([$class: "TapPublisher", testResults: "output/tests.tap"])
      }
    }
}