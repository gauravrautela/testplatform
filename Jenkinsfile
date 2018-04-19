pipeline {
  stages {

    stage('SCM checkout') {
          steps {
		timestamps {
   	 timeout(time: 60, unit: 'SECONDS') {
              sh 'sh script1'
          }
      }
	}
	}

   stage('CODE buiding deploy') {
              steps {
    timeout(time: 60, unit: 'SECONDS') {
                  sh './hello.sh'
              }
          }
	}


    }



    post {
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
