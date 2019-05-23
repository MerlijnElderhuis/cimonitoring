pipeline {
  agent any

  environment{
    scannerHome = tool 'sonar-scanner'
  }
  post {
    always {
      sh "docker-compose down -v"
    }
  }
  options {
    gitLabConnection('gitlab-connection')
    gitlabBuilds(builds: ['start-docker-compose', 'rubocop', 'rspec', 'sonarqube'])
  }
  triggers {
    gitlab(triggerOnPush: true, triggerOnMergeRequest: false, branchFilterType: 'All')
  }
  stages {
    stage('start-docker-compose'){
      steps{
        gitlabCommitStatus(name: 'start-docker-compose'){
          sh 'docker-compose up -d' // --build'
        }
      }
    }
    stage('rubocop'){
      steps{
        gitlabCommitStatus(name: 'rubocop'){
          sh 'docker-compose run web bundle exec rubocop --rails'
        }
      }
    }
    stage('rspec'){
      steps{
        gitlabCommitStatus(name: 'rspec'){
          sh 'docker-compose run web rake db:create db:migrate spec'
          sh 'mkdir -p reports'
          sh 'cp coverage/.resultset.json reports/.resultset.json'
          sh "sed -i 's+/app/app+/var/lib/jenkins/workspace/mbpipeline_master/app+g' reports/.resultset.json"
        }
      }
    }
    stage('sonarqube'){
      steps{
        gitlabCommitStatus(name: 'sonarqube'){
          withSonarQubeEnv('sonarqube-jenkins'){
            sh "${scannerHome}/bin/sonar-scanner"
            sh 'ls -la'
            sh 'pwd'
            sh 'cat sonar-project.properties'
          }
        }
      }
    }
  }
}
