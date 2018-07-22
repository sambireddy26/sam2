// Read yml file and inject keys into build environment variables
def readYMLEnvironmentKeys(GIT_BRANCH_LOCAL) {

  def yml_data = readYaml file: 'Jenkins\\commit\\build.yml'
  // Iterate over branch key in yml_data
  for ( branch_name in yml_data ) {
    if ( branch_name.key == GIT_BRANCH_LOCAL ) {
      env.SONAR_PROJECT_NAME = yml_data[branch_name.key]['SONAR_PROJECT_NAME']
      env.SONAR_PRJECT_KEY = yml_data[branch_name.key]['SONAR_PRJECT_KEY']
      env.SONAR_EXCLUSIONS = yml_data[branch_name.key]['SONAR_EXCLUSIONS']
      env.SONAR_JAVA_BINARIES = yml_data[branch_name.key]['SONAR_JAVA_BINARIES']
      env.EMAIL_TO = yml_data[branch_name.key]['EMAIL_TO']
      break
    }
  }
  if (env.EMAIL_TO == null) {
    error("Build failed because there's unmatch paramters in build.yml file..")
  }

}

pipeline {
  agent {
    node {
      label 'master'
    }
  }
  // Define scheduler
  triggers {
    pollSCM('* * * * *')
  }
  // Define build properties
  options {
    buildDiscarder(logRotator(numToKeepStr:'30', artifactNumToKeepStr:'30'))
    timestamps()
    disableConcurrentBuilds()
  }
  // Injecting credentials into environment variables
  environment {
  //  NEXUS_PASSWORD = credentials('NEXUS_PASSWORD')
   // NEXUS_PUBLISHER_PASSWORD = credentials('NEXUS_PUBLISHER_PASSWORD')
  }
  stages {
    stage ('Checkout Code') {
      steps {
        script {
          def GIT_BRANCH_LOCAL = "${GIT_BRANCH}" - "origin/"
          readYMLEnvironmentKeys(GIT_BRANCH_LOCAL)
        }
        // Deleteing Workspace
        deleteDir()
        // Git clone steps
        git branch: '${BRANCH_NAME}', credentialsId: 'fb5dgfjjkghhvmgg', url: 'git@bmbnmd.git'
      }
      post {
        failure {
          echo "Build Step Failed"
        }
      }
    }
    stage ('UnitTest Cases') {
      steps {
        //Running powershell script for unit test cases
       // powershell '.\\gradlew.bat -P nexusUrl=$env:NEXUS_URL -P nexusUsername=$env:NEXUS_USERNAME -P nexusPassword=$env:NEXUS_PASSWORD -P nexusPublisherUsername=$env:NEXUS_PUBLISHER_USERNAME -P nexusPublisherPassword=$env:NEXUS_PUBLISHER_PASSWORD clean build jacocoRootReport'
      }
      post {
        failure {
          echo "Build Step Failed"
        }
      }
    }
    // stage ('Publish Artifacts') {
    //   steps {
    //     // Running powershell script for publish artifacts
    //     powershell '.\\gradlew.bat -P nexusUrl=$env:NEXUS_URL -P nexusUsername=$env:NEXUS_USERNAME -P nexusPassword=$env:NEXUS_PASSWORD -P nexusPublisherUsername=$env:NEXUS_PUBLISHER_USERNAME -P nexusPublisherPassword=$env:NEXUS_PUBLISHER_PASSWORD publish'
    //   }
    //   post {
    //     failure {
    //       echo "Build Step Failed"
    //     }
    //   }
    // }
    // stage ('ChangeSet Publish') {
    //   // Adding conditionn here which handles a stage execution when we runs a pipeline for a first time.
    //   when {
    //     expression {
    //       env.GIT_PREVIOUS_SUCCESSFUL_COMMIT
    //     }
    //   }
    //   steps {
    //     //Running powershell script for changeSet artifacts uploaded on S3
    //     powershell '.\\Jenkins\\scripts\\changeSet.ps1 -GIT_COMMIT $env:GIT_COMMIT -GIT_PREVIOUS_SUCCESSFUL_COMMIT $env:GIT_PREVIOUS_SUCCESSFUL_COMMIT -GIT_BRANCH $env:GIT_BRANCH -NEXUS_URL $env:NEXUS_URL -NEXUS_PASSWORD $env:NEXUS_PASSWORD -NEXUS_USERNAME $env:NEXUS_USERNAME -WORKSPACE $env:WORKSPACE -KERNAL_SNAPSHOT $env:KERNAL_SNAPSHOT'
    //   }
    //   post {
    //     failure {
    //       echo "Build Step Failed"
    //     }
    //   }
    // }
    stage ('Sonar Code Quality Scan') {
      steps {
        script {
          // Set Sonar Path
         // ------ scannerHome = tool 'Sonar scanner'
        }

        // Execute Sonnar Scanner
       //--------- withSonarQubeEnv('sonarqube server') {
        //-----------  bat "${scannerHome}/bin/sonar-scanner.bat -Dsonar.projectKey=${SONAR_PRJECT_KEY} -Dsonar.projectVersion=${BUILD_NUMBER} -Dsonar.sources=. -Dsonar.projectName=${env.SONAR_PROJECT_NAME} -Dsonar.exclusions=${env.SONAR_EXCLUSIONS} -Dsonar.java.binaries=${env.SONAR_JAVA_BINARIES} -Dsonar.jacoco.reportPath=build/jacoco/jacocoRootMerge.exec"
        echo ${BUILD_NUMBER}
        echo ${env.SONAR_PROJECT_NAME}
        echo ${env.SONAR_EXCLUSIONS}
        echo ${env.SONAR_JAVA_BINARIES}
        }
      }
      post {
        failure {
          echo "Build Step Failed"
        }
      }
    }
  }
  // Hook notification
  post {
    success {
      echo "Pipeline executed Successfully"
    }
    changed {
      emailext (
        subject: "CHANGED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
        body: """<p>CHANGED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
            <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
        mimeType: "text/html",
        to: "${env.EMAIL_TO}"
      )
    }
    failure {
      emailext (
        subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
        body: """<p>FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
            <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
        mimeType: "text/html",
        to: "${env.EMAIL_TO}"
      )
    }
  }
}
