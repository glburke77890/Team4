pipeline {
    agent any

    
    stages {
        stage('Login, Build and Push'){
            steps {
                script{
                    //sign into docker, build image, and push image to dockerhub
                    withDockerRegistry(credentialsId: 'Docker') {
                        docker.build('dsassenger/flaskapp').push('latest')
                    }
                }
            }
        }
        stage('AWS Commands'){
            steps {
                
                    // sign into AWS
                    
                        sh 'aws sts get-caller-identity'
                    
            }
        }
        stage('Kubernetes login'){
            steps{

                    //Exact same for everyone in the class except the credential variable, use your own credential variable id.  Update kubeconfig in container
                    
                        sh 'aws eks update-kubeconfig --region us-east-1 --name Team4-cluster'


            }
        }
        stage('Create Namespace'){
            steps {
                script {
                    try {
                            sh 'kubectl apply -f manifest.yaml'
                            sh 'kubectl rollout restart deployment flask-deployment -n Team4-namespace'
                        } catch (Exception e) {
                            echo 'Exception occured: ' + e.toString()
                            echo 'Handled the Exception!'
                    }
                }
                
        stage('terraform init')
            steps {
                sh ('terraform init')
            }
        }

        stage ("terraform Apply") {
            steps {
                sh 'terraform apply --auto-approve'
                }
            }
        }
    }
}{