pipeline {

    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: alpine
    image: alpine:latest
    command:
    - cat
    tty: true
  - name: docker-compose
    image: docker/compose:latest
    command:
    - cat
    tty: true
    volumeMounts:
    - mountPath: /var/run/docker.sock
      name: docker-sock
  volumes:
    - name: docker-sock
      hostPath:
        path: /var/run/docker.sock
'''
        }
    }

    environment {
        BUILD_NUMBER = "${env.BUILD_NUMBER}"
    }

    options {
        skipDefaultCheckout(true)
        buildDiscarder(logRotator(numToKeepStr: '2'))
    }

    stages {
        stage('Initialize') {
            steps {
                echo '> Initializing Build ...'
                checkout scm
                echo '> Initialize : Build Successful'
            }
        }
        stage('Build') {
            steps {
                echo '> Building images using docker-compose'
                container('docker-compose'){
                    sh "docker images"
                    sh "ls -ltr"
                }
                echo '> Build Successful'
            }
        }
        stage('Test') {
            steps {
                echo '> Testing the docker containers ...'
                echo '> Tests Successful'
            }
        }
        stage('Publish') {
            steps {
                echo '> Start Publishing of Images and Artifacts...'
                echo '> Publishing of Images and Artifacts Done!'
            }                
        }
        stage('Deploy') {
            steps {
				echo '> Deployment Done!'
            }
        }
    }

    post {
        cleanup {
            echo '> cleaning-up the docker build images ...'
        }
    }
}
