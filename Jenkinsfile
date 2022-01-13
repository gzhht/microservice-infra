pipeline {    
  parameters {
    choice(name: 'service_choice',
      choices: 'admin\ngateway\nmongoDB',
      description: 'What infrastructure service do you deploy?')
    choice(name: 'deploy_env_choice',
      choices: 'default\nDEV\nUAT',
      description: 'deploy_all_fra_services')  
    booleanParam(name: 'deploy_all_services',
      defaultValue: false,
      description: 'deploy all  infra services for application service')
    string(name: 'deploy_reason',
      defaultValue: 'General upgrading or Tesing new feature',
      description: 'Given some reson when deploy all')
  }

    agent none

    stages {

        stage('Clone repository') {

            agent any

            steps {
            /* Clone our repository */
                checkout scm
            }    
        }

        stage('Deploy requirement') {

            agent any
            
            steps {
                echo 'Will do follow list'
                echo "Chose Service: ${params.service_choice}"
                echo "Chose Env: ${params.deploy_env_choice}"
                echo "Deploy all services: ${params.deploy_all_services}"
                echo "Why Deploy all: ${deploy_reason}"
            }
        }

        stage('Deploying all services') {

            agent any
            
            when {
                expression { 
                   return params.deploy_all_services == true
                }
            }
            steps {
                input message: "Process to deploy all services"
                echo "deploying all"
            }
        }

        stage('Building chose services') {
            parallel {
                stage("Building ${params.service_choice} service") {
                    agent {
                        docker {
                            image 'maven:3-alpine'
                            args '-v /root/.m2:/root/.m2'
                        }
                    }    
                    when {
                        expression { 
                        return params.deploy_all_services == false
                        }
                    }
                    steps {
                        
                        echo "build ${params.service_choice}-service"
                        dir("${params.service_choice}-service") {
                            
                            echo "in project ${params.service_choice}-service"
                            sh 'mvn -B -DskipTests clean package'
                        }
                    }
                }
            }  
        }
        
        stage('Deploying chose services') {
            parallel {
                stage("Deploying ${params.service_choice} service") {
                    
                    agent any 
                    when {
                        expression { 
                        return params.deploy_all_services == false
                        }
                    }
                    steps {
                        
                        echo "build ${params.service_choice}-service"
                        dir("${params.service_choice}-service") {
                            
                            echo "in project ${params.service_choice}-service"

                            withEnv([
                                        "SERVICE=${params.service_choice}",
                                        "TAG=latest"
                                    ]){
                                    /* Build the docker image */
                                        sh 'echo "clear <none docker images>"'
                                        sh "../ci-build/clear-images.sh"
                                        sh "docker build --no-cache -t ${SERVICE}:${TAG} ."
                                    }
                        }
                    }
                }
            }
        }

        stage("Env deploy") {
            
            agent any
            
            input {
                message "Should we continue?"
                ok "Yes, we should."
                submitter "alice,bob"
                parameters {
                    string(name: 'PERSON', defaultValue: 'Jason/Dave/Selina', description: 'Who process to deploy?')
                }
            }

            steps {
                echo "Hello, ${PERSON}, executeing your choose."
            }
        }

        stage('Deliver for development') {

            agent any
            
            steps {
                dir("k8s") {
                    echo 'in k8s folder'
                    sh "ls"
                    input message: 'Finished using the web site? (Click "Proceed" to continue)'
                    sh "cat privileges.yaml"
                    echo 'executing'
                }
                echo 'in man folder'
                sh "ls"
                dir("admin-service") {
                    echo 'in admin-service folder'
                    sh "ls -a"
                }
            }
        }
   
    }
}