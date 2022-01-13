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
                input message: "Prepare parallel to Process deploying all services"
                echo "deploying all ..."
            }
        }

        stage('Building chose services') {
            parallel {
                stage("Building admin service") {
                    agent {
                        docker {
                            image 'maven:3-alpine'
                            args '-v /root/.m2:/root/.m2'
                        }
                    }    
                    when {
                        expression { 
                            return params.deploy_all_services == true || params.service_choice == 'admin'
                        }
                    }
                    steps {
                        
                        echo "build admin-service"
                        dir("admin-service") {
                            
                            echo "Building in project admin-service"
                            sh 'mvn -B -DskipTests clean package'
                        }
                    }
                }
                stage("Building gateway service") {
                    agent {
                        docker {
                            image 'maven:3-alpine'
                            args '-v /root/.m2:/root/.m2'
                        }
                    }    
                    when {
                        expression { 
                            return params.deploy_all_services == true || params.service_choice == 'gateway'
                        }
                    }
                    steps {
                        
                        echo "build gateway-service"
                        dir("gateway-service") {
                            
                            echo "Building in project gateway-service"
                            sh 'mvn -B -DskipTests clean package'
                        }
                    }
                }
            }  
        }

        stage('Deploying chose services') {
            parallel {
                stage("Deploying admin service") {
                    
                    agent any 
                    when {
                        expression { 
                            return params.deploy_all_services == true || params.service_choice == 'admin'
                        }
                    }
                    steps {
                        
                        echo "build admin-service"
                        dir("admin-service") {
                            
                            echo "in project admin-service"

                            withEnv([
                                        "SERVICE=admin",
                                        "NAMESPACE=${params.deploy_env_choice}",
                                        "TAG=latest"
                                    ]){
                                    /* Build the docker image */
                                        sh 'echo "clear <none docker images>"'
                                        sh "../ci-build/clear-images.sh"
                                        echo "building docker image ..."
                                        sh "docker build --no-cache -t ${SERVICE}:${TAG} ."
                                        echo "Deploy image to k8s cluster [env ${params.deploy_env_choice}]  ..."
                                        sh "./deployment/deploy.sh"
                                    }
                        }
                    }
                }
                stage("Deploying gateway service") {
                    
                    agent any 
                    when {
                        expression { 
                            return params.deploy_all_services == true || params.service_choice == 'gateway'
                        }
                    }
                    steps {
                        
                        echo "build gateway-service"
                        dir("gateway-service") {
                            
                            echo "in project gateway-service"

                            withEnv([
                                        "SERVICE=gateway",
                                        "NAMESPACE=${params.deploy_env_choice}",
                                        "TAG=latest"
                                    ]){
                                    /* Build the docker image */
                                        sh 'echo "clear <none docker images>"'
                                        echo "building docker image ..."
                                        sh "docker build --no-cache -t ${SERVICE}:${TAG} ."
                                        echo "Deploy image to k8s cluster [env ${params.deploy_env_choice}]  ..."
                                        sh "./deployment/deploy.sh"
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