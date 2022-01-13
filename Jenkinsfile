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
  stages {
    stage('Example') {
      steps {
        echo 'Hello World!'
        echo "Trying: ${params.door_choice}"
        echo "We can dance: ${params.CAN_DANCE}"
        echo "The DJ says: ${params.sTrAnGePaRaM}"
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
    }
}
