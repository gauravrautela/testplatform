peline {
  agent { node { label 'master' } }
  triggers {
    cron('*/10 * * * *')
    }
    options {
      buildDiscarder(logRotator(numToKeepStr: '15', artifactNumToKeepStr: '15'))
    }


  stages {


    stage('Run first script') {
          steps {
              sh 'script1'
          }
      }

    stage('Run second script') {
              steps {
                  sh 'script2'
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
      failure {
            mail to: 'gauravrautela16@gmail.com',
            subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
            body: "Something is wrong with ${env.BUILD_URL}"
           }


        }

}
