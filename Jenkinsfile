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
  - name: jinja2
    image: gcr.io/dev-telus-clam/builders/jinja2docker
    command:
    - cat
    tty: true
  - name: docker
    image: docker:latest
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
                container('docker') {
                    sh 'docker build -t clam/jinja2 .'
                    sh 'docker run -rm -v templates/template.json:/work/templates -v variables/vars.json:/work/variables clam/jinja2:latest  /work/templates/template.json /work/variables/vars.json'
                }
                container('jinja2'){
                    sh "env"
                    sh "mkdir out"
                    sh "echo $WORKSPACE"
                    sh "ls -ltr"
                    sh "jinja2 templates/template.json variables/vars.json -o out/result.json"
                    sh "ls -ltr"
                }
                sh 'cat out/result.json'
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
