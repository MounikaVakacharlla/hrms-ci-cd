pipeline {

    agent any

    options {
        timeout(time: 30, unit: 'MINUTES')
    }

    environment {

        IMAGE_NAME = "blackroth/hrms"
        VERSION = "1.${BUILD_NUMBER}"

    }


    stages {


        stage('Install Dependencies') {

            steps {

                sh '''
                if [ ! -d "venv" ]; then
                    python3 -m venv venv
                fi

                . venv/bin/activate

                pip install --cache-dir ~/.cache/pip -r requirements.txt
                '''

            }

        }



        stage('Parallel Testing') {

            parallel {


                stage('Django Tests') {

                    steps {

                        sh '''
                        mkdir -p reports

                        venv/bin/pytest \
                        > reports/test-report.xml || true
                        '''

                    }

                }



                stage('Flake8') {

                    steps {

                        sh '''
                        mkdir -p reports

                        venv/bin/flake8 . \
                        > reports/flake8.txt || true
                        '''

                    }

                }



                stage('Security Scan') {

                    steps {

                        sh '''
                        mkdir -p reports

                        venv/bin/bandit -r . \
                        --exclude venv,.git,reports \
                        > reports/security.txt || true
                        '''

                    }

                }


            }

        }




        stage('Archive Reports') {

            steps {

                archiveArtifacts(
                    artifacts: 'reports/*',
                    allowEmptyArchive: true
                )

            }

        }




        stage('Docker Build') {

            steps {

                sh """

                docker build \
                --no-cache=false \
                -t ${IMAGE_NAME}:${VERSION} .

                """

            }

        }




        stage('Docker Push') {

            steps {


                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {


                    sh '''

                    echo $DOCKER_PASS | docker login \
                    -u $DOCKER_USER \
                    --password-stdin


                    docker push ${IMAGE_NAME}:${VERSION}

                    '''

                }


            }

        }





        stage('Deploy Staging') {

            steps {


                sh """

                bash scripts/deploy.sh ${VERSION}

                """

            }

        }





        stage('Health Check') {

            steps {


                sh """

                bash scripts/healthcheck.sh

                """

            }

        }





        stage('Production Approval') {

            steps {


                input(
                    message: "Deploy ${VERSION} to Production?"
                )


            }

        }





        stage('Production Deployment') {

            steps {


                sh """

                bash scripts/deploy.sh ${VERSION}

                """


            }

        }


    }




    post {


        failure {

            sh """

            bash scripts/rollback.sh previous

            """

        }



        success {

            echo "Deployment Successful"

        }


    }


}
