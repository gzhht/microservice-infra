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

    agent any

    stages {


        stage('Clone repository') {
            steps {
            /* Clone our repository */
                checkout scm
            }    
        }

        stage('Deploy requirement') {
            steps {
                echo 'Will do follow list'
                echo "Chose Service: ${params.service_choice}"
                echo "Chose Env: ${params.deploy_env_choice}"
                echo "Deploy all services: ${params.deploy_all_services}"
                echo "Why Deploy all: ${deploy_reason}"
            }
        }

        stage('Deploying all services') {
            when {
                expression { 
                   return ${params.deploy_all_services}
                }
            }
            steps {
                input message: "Process to deploy all services"
                echo "deploying all"
            }
        }

        stage('Deploying Single service') {
            agent {
                docker {
                    image 'maven:3-alpine'
                    args '-v /root/.m2:/root/.m2'
                }
            }    
            when {
                expression { 
                   return ${params.deploy_all_services} == false
                }
            }
            steps {
                
                input message: "Process to deploy ${params.service_choice}-service"
                echo "deploying ${params.service_choice}-service"
                dir("${params.service_choice}-service") {
                    echo "in project ${params.service_choice}-service"
                    sh 'mvn -B -DskipTests clean package'
                }
            }
        }

        stage("Env deploy") {
            
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