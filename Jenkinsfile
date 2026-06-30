stage('Parallel Testing') {

parallel {


stage('Django Tests') {

steps {

sh '''

. venv/bin/activate

mkdir -p reports

pytest > reports/test-report.xml || true

'''

}

}



stage('Flake8') {

steps {

sh '''

. venv/bin/activate

mkdir -p reports

flake8 . > reports/flake8.txt || true

'''

}

}



stage('Security Scan') {

steps {

sh '''

. venv/bin/activate

mkdir -p reports

bandit -r . --exclude venv,.git,reports > reports/security.txt || true

'''

}

}


}

}
