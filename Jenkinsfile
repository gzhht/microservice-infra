pipeline {    
  parameters {
    choice(name: 'door_choice',
      choices: 'one\ntwo\nthree\nfour',
      description: 'What door do you choose?')
    booleanParam(name: 'CAN_DANCE',
      defaultValue: true,
      description: 'Checkbox parameter')
    string(name: 'sTrAnGePaRaM',
      defaultValue: 'Dance!',
      description: 'Do the funky chicken!')
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
            echo 'Hello World!'
            echo "Trying: ${params.door_choice}"
            echo "We can dance: ${params.CAN_DANCE}"
            echo "The DJ says: ${params.sTrAnGePaRaM}"
        }
        }

        stage("Env deploy") {
            
            when {
                expression { params.region == 'admin' || params.region == 'gateway' || params.region == 'mongodb'}
            }
            steps {
                script {
                    if(params.region == 'admin') {
                        input message: "Proceed or Abort", submitter: "env admin",
                        echo 'params.region is deploying'
                    } 

                    if(params.region == 'gateway') {
                        input message: "Proceed or Abort", submitter: "env admin",
                        echo 'params.region is deploying'
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