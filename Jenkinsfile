pipeline {    
  parameters {
    choice(name: 'service_choice',
      choices: 'admin\ngateway\nmongoDB',
      description: 'What infrastructure service do you deploy?')
    choice(name: 'deploy_env_choice',
      choices: 'default\nDEV\nUAT',
      description: 'deploy_all_fra_services')  
    booleanParam(name: 'Re-deploy all Services',
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

        stage('Example') {
            steps {
                echo 'Will do follow list'
                echo "Chose Service: ${params.service_choice}"
                echo "Chose Env: ${params.deploy_env_choice}"
                echo "Deploy all services: ${params.deploy_all_services}"
                echo "Why Deploy all: ${deploy_reason}"
            }
        }

        stage("Env deploy") {
            
            input {
                message "Should we continue?"
                ok "Yes, we should."
                submitter "alice,bob"
                parameters {
                    string(name: 'PERSON', defaultValue: 'admin/gateway/mongoDB', description: 'Who should I say hello to?')
                }
            }

            steps {
                script {
                    if(${PERSON} == 'admin') {
                        input message: "Proceed or Abort", submitter: "env admin",
                        echo '${PERSON} is deploying'
                    } 

                    if(${PERSON} == 'gateway') {
                        input message: "Proceed or Abort", submitter: "env gateway",
                        echo '${PERSON} is deploying'
                    } 
                }
            }
        }

        stage('Deliver for development') {
            steps {
                dir("k8s") {
                    echo 'in k8s folder'
                    sh "ll -a"
                    input message: 'Finished using the web site? (Click "Proceed" to continue)'
                    sh "cat privileges.yaml"
                    echo 'executing'
                }
                echo 'in man folder'
                sh "ll -a"
                dir("admin-service") {
                    echo 'in admin-service folder'
                    sh "ll -a"
                }
            }
        }
   
    }
}