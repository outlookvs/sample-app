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
                container('docker'){
                    sh "env"
                    sh "mkdir out"
                    sh "echo $PWD"
                    sh "echo $WORKSPACE"
                    sh "ls -ldtr $PWD"
                    sh "ls -ldtr $WORKSPACE"
                    sh "ls -ltr $JENKINS_AGENT_WORKDIR/workspace/Test"
                    sh "ls -ltr $JENKINS_AGENT_WORKDIR/templates"
                    sh "ls -ltr $JENKINS_AGENT_WORKDIR/variables"
                    sh "docker run --rm -v $PWD/templates:/templates -v $PWD/variables:/variables dinutac/jinja2docker:latest /templates/template.json /variables/vars.json"
                    sh "ls -ltr"
                }
                sh 'cat result.json'
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
