
pipeline {


agent any


environment {


IMAGE_NAME="blackroth/hrms"

VERSION="1.${BUILD_NUMBER}"


}


stages {





stage('Install Dependencies'){


steps{


sh '''

python3 -m venv venv

. venv/bin/activate


pip install -r requirements.txt


'''


}


}





stage('Parallel Testing'){


parallel {



stage('Django Tests'){


steps{


sh '''

. venv/bin/activate

pytest > reports/test-report.xml || true


'''


}


}



stage('Flake8'){


steps{


sh '''

flake8 . > reports/flake8.txt || true


'''


}


}



stage('Security Scan'){


steps{


sh '''

bandit -r . --exclude venv > reports/security.txt || true


'''


}


}



}


}





stage('Archive Reports'){


steps{


archiveArtifacts artifacts:'reports/*',
allowEmptyArchive:true


}


}






stage('Docker Build'){


steps{


sh """


docker build \
-t ${IMAGE_NAME}:${VERSION} .


"""


}


}




stage('Docker Push'){


steps{


sh """


docker push ${IMAGE_NAME}:${VERSION}


"""


}


}





stage('Deploy Staging'){


steps{


sh """


bash scripts/deploy.sh ${VERSION}


"""


}


}




stage('Health Check'){


steps{


sh """


bash scripts/healthcheck.sh


"""


}


}





stage('Production Approval'){


steps{


input message:
"Deploy ${VERSION} to Production?"


}


}






stage('Production Deployment'){


steps{


sh """


bash scripts/deploy.sh ${VERSION}


"""


}


}



}



post {



failure{


sh """


bash scripts/rollback.sh previous


"""


}




success{


echo "Deployment Successful"


}


}


}
