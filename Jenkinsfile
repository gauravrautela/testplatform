pipeline {
  agent { node { label 'master' } }
  triggers {
    cron('*/10 * * * *')
    }
    options {
      buildDiscarder(logRotator(numToKeepStr: '15', artifactNumToKeepStr: '15'))
    }


  stages {

    timeout(time: 60, unit: 'SECONDS') {
    stage('Run first script') {
          steps {
              sh 'sh script1'
          }
      }
}
  timeout(time: 60, unit: 'SECONDS') { 
   stage('Run second script') {
              steps {
                  sh 'sh script2'
              }
          }
}


    }



    post {

      always  {
        echo 'cleaning workspace'
        deleteDir()
              }

      failure {
            mail to: 'gauravrautela16@gmail.com',
            subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
            body: "Something is wrong with ${env.BUILD_URL}"
        }
      unstable {
            mail to: 'gauravrautela16@gmail.com',
            subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
            body: "Something is wrong with ${env.BUILD_URL}"
           }


        }

}
