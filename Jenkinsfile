pipeline {
  agent any

  environment {
    APP_NAME = "devops-demo"
    IMAGE_REPO = "${DOCKERHUB_USERNAME}/${APP_NAME}"
    IMAGE_TAG = "${BUILD_NUMBER}"
    KUBE_NAMESPACE = "devops-demo"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Test') {
      steps {
        sh '''
          python3 -m venv .venv
          . .venv/bin/activate
          pip install -r app/requirements.txt pytest
          pytest
        '''
      }
    }

    stage('Build Image') {
      steps {
        sh 'docker build -t ${IMAGE_REPO}:${IMAGE_TAG} .'
      }
    }

    stage('Push Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker push ${IMAGE_REPO}:${IMAGE_TAG}
          '''
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        sh '''
          kubectl create namespace ${KUBE_NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -
          sed "s|__IMAGE__|${IMAGE_REPO}:${IMAGE_TAG}|g" k8s/deployment.yaml | kubectl apply -n ${KUBE_NAMESPACE} -f -
          kubectl apply -n ${KUBE_NAMESPACE} -f k8s/service.yaml
        '''
      }
    }
  }
}
