if (currentBuild.getBuildCauses().toString().contains('BranchIndexingCause') || currentBuild.getBuildCauses().toString().contains('Branch event')) {
  print "INFO: Build skipped due to trigger being Branch Indexing"
  currentBuild.result = 'ABORTED' // optional, gives a better hint to the user that it's been skipped, rather than the default which shows it's successful
  return
}

pipeline {
   agent any
   options {
        // Number of build logs to keep
        // @see https://www.jenkins.io/doc/book/pipeline/syntax/
        buildDiscarder(logRotator(numToKeepStr: '5'))
        //Pipeline speed, much faster, Greatly reduces disk I/O - requires clean shutdown to save running pipelines
        durabilityHint('PERFORMANCE_OPTIMIZED')
        // Disallow concurrent executions of the Pipeline. Can be useful for preventing simultaneous accesses to shared resources
        disableConcurrentBuilds()
   }
   triggers {
        // Accepts a cron-style string to define a regular interval at which Jenkins should check for new source changes 
	// If new changes exist, the Pipeline will be re-triggered
        pollSCM 'H/5 * * * *'
        //githubPullRequests(triggerMode: "CRON",
        //                   events: [open, commitChanged]) 
	pullRequestReview(reviewStates: ['pending', 'approved', 'changes_requested'])
   } //branchRestriction: "master"
   environment {
        SLACK_TEAM_DOMAIN = "wcmc"
        SLACK_TOKEN = credentials('slack-token-test-jenkinsci')
        SLACK_CHANNEL = "#test-jenkinsci"
        COMPOSE_FILE = "docker-compose.yml"
	GIT_COMMIT_MSG = sh (script: 'git log -1 --pretty=%B ${GIT_COMMIT}', returnStdout: true).trim()
	SNYK_URL = "https://app.snyk.io/org/olaiyafunmmi/projects"
        jenkinsConsoleUrl = "$env.JOB_URL" + "$env.BUILD_NUMBER" + "/consoleText"
        DIR = "$JENKINS_HOME/workspace"
   } //SLACK_TOKEN = credentials('slack-token-sapi') SLACK_CHANNEL = "#jenkins-cicd-sapi"   SNYK_URL = "https://app.snyk.io/org/informatics.wcmc/projects"
   stages {
        stage ('Start') {
            steps {
                slackSend(
                    teamDomain: "${env.SLACK_TEAM_DOMAIN}",
                    token: "${env.SLACK_TOKEN}",
                    channel: "${env.SLACK_CHANNEL}",
                    color: "#FFFF00",
                    message: "STARTED: Branch -- PULL REQUEST SOURCE BRANCH: ${env.CHANGE_BRANCH}:::::${env.CHANGE_TITLE}\n ${env.BRANCH_NAME}\n Git Commit message: '${env.GIT_COMMIT_MSG}'\n Job: ${env.JOB_NAME} - [${env.BUILD_NUMBER}]' \n Build link: [(<${env.BUILD_URL} | View >)]"
                )
	    }
       	}
	stage("printenv") {
            steps { 
		script {
		    CI_ERROR = "failed at printenv"
                    sh "printenv" 
		    sh "echo $env.CHANGE_TITLE"
		}
	    }
        }
	stage("Build") {
            steps { 
	        script {
	            CI_ERROR = "Build Failed at stage: docker-compose build"
                    buildProject()
	        }
	    }
        }
        stage("Test DB") {
            steps { 
		script {
		    CI_ERROR = "Build Failed at stage: Test DB - Running docker-compose db test and migrate"
                    prepareDatabase() 
		}
	    }
        }
        stage('Scan for vulnerabilities') {
            when{
                expression {
                    return env.BRANCH_NAME ==~ /(develop|master|((build|ci|feat|fix|perf)\/.*))/
                }
            }
	    steps {
		script {
	            CI_ERROR = "Build Failed at stage:: Snyk vulnerability scan failed for this project, check the snyk site for details, ${env.SNYK_URL}"
		}
                echo 'Scanning...'
                snykSecurity(
        		snykInstallation: 'snyk@latest', snykTokenId: 'wcmc-snyk',
		    	severity: 'critical', failOnIssues: true,
		    	additionalArguments: '--all-projects --detection-depth=4', 
			)
	    }
	    post {
                success{
                    slackSend color: "good", message: "Snyk scan successful, visit ${env.SNYK_URL} for detailed report", teamDomain: "${env.SLACK_TEAM_DOMAIN}", token: "${env.SLACK_TOKEN}", channel: "${env.SLACK_CHANNEL}"
                }
                failure{
                    slackSend color: "danger", message: "Snyk scan failed, visit ${env.SNYK_URL} to get detailed report", teamDomain: "${env.SLACK_TEAM_DOMAIN}", token: "${env.SLACK_TOKEN}", channel: "${env.SLACK_CHANNEL}"
                }
            }
    	}
	stage("Deploy to Staging") { 
            when {
                branch 'testsapinewdeploy'
            }
            steps { 
               	script {
		    CI_ERROR = "Build Failed at stage: Prepare deploy stage"
		    sh "mkdir $DIR/deploysapi"
		    dir("$DIR/deploysapi") {
		        checkout scm
         		deploy()
		    }
            	}
            }
            post {
		always {
	             script {
			 deleteDeployDir()
		     }
		}
                success{
                    slackSend color: "good", message: "Deploy to Staging server successful", teamDomain: "${env.SLACK_TEAM_DOMAIN}", token: "${env.SLACK_TOKEN}", channel: "${env.SLACK_CHANNEL}"
                }
                failure{
                    slackSend color: "danger", message: "Deploy to Staging server failed", teamDomain: "${env.SLACK_TEAM_DOMAIN}", token: "${env.SLACK_TOKEN}", channel: "${env.SLACK_CHANNEL}"
                }
            }
        }
    }
    post {
        always {
	     script {
               	BUILD_STATUS = currentBuild.currentResult
		if (currentBuild.currentResult == 'SUCCESS') { 
			CI_ERROR = "NA" 
		}
		dockerImageCleanup()
                }
        }
	 success {
            slackSend(
                teamDomain: "${env.SLACK_TEAM_DOMAIN}",
                token: "${env.SLACK_TOKEN}",
                channel: "${env.SLACK_CHANNEL}",
                color: "good",
                message: "Job:  ${env.JOB_NAME}\n Build: ${env.BUILD_NUMBER} -- Completed for [${env.JOB_NAME}]\n Status: *SUCCESS* \n Result: Pipeline has finished build successfully for - - ${currentBuild.fullDisplayName} :white_check_mark:\n Run Duration: [${currentBuild.durationString}]\n View Build: [(<${JOB_DISPLAY_URL} | View >)]\n Logs path and Details: [(<${jenkinsConsoleUrl} | here >)] \n"
            )
        }
        failure {
            slackSend(
                teamDomain: "${env.SLACK_TEAM_DOMAIN}",
                token: "${env.SLACK_TOKEN}",
                channel: "${env.SLACK_CHANNEL}",
                color: "danger",
                message: "Job:  ${env.JOB_NAME}\n Status: *FAILURE* \n Result: Pipeline has failed for - - ${currentBuild.fullDisplayName}❗\n Error description: ${CI_ERROR}\n Run Duration: [${currentBuild.durationString}]\n View Build: [(<${JOB_DISPLAY_URL} | View >)]\n Logs path and Details: [(<${jenkinsConsoleUrl} | here >)] \n"
            )
        }
        cleanup {
	    cleanWs()
	    deleteWorkspace()
	}
    }

}



def buildProject() {
    sh 'echo "Building Project.............."'
    sh "cp .env-jenkins .env"
    sh "cp config/database.yml.jenkins config/database.yml"
    sh "cp config/sidekiq.yml.jenkins config/sidekiq.yml"
    sh "cp config/secrets.yml.jenkins config/secrets.yml"
    sh "docker-compose -f ${COMPOSE_FILE} --project-name=${JOB_NAME} build --pull"
}

def prepareDatabase() {
    COMMAND = "bundle exec rake db:drop db:create db:migrate"
    sh "docker-compose --project-name=${JOB_NAME} run -e RAILS_ENV=test web ${COMMAND}"
}

def runRspecTests() {
    COMMAND = "bundle exec rspec spec"
    sh "docker-compose --project-name=${JOB_NAME} run web ${COMMAND}"
}

def deploy() {
    sh '''#!/bin/bash -l
        eval $(ssh-agent)
        ssh-add /tmp/id_deploy
        git checkout testsapinewdeploy
        rvm use $(cat .ruby-version) --install
        bundle install
        echo "bundle exec cap staging deploy --trace"
    '''
} //cp config/database.yml.sample config/database.yml

def dockerImageCleanup() {
    sh "docker-compose --project-name=${JOB_NAME} stop &> /dev/null || true &> /dev/null"
    sh "docker-compose --project-name=${JOB_NAME} rm --force &> /dev/null || true &> /dev/null"
    sh "docker stop `docker ps -a -q -f status=exited` &> /dev/null || true &> /dev/null"
    sh "docker-compose --project-name=${JOB_NAME} down --volumes &> /dev/null || true &> /dev/null"
    sh '''#!/bin/bash
	docker ps -a --no-trunc  | grep "sapi" | awk '{print $1}' | xargs -r --no-run-if-empty docker stop
	docker ps -a --no-trunc  | grep "sapi" | awk '{print $1}' | xargs -r --no-run-if-empty docker rm -f
	docker images --no-trunc | grep "sapi" | awk '{print $3}' | xargs -r --no-run-if-empty docker rmi -f
    '''    
}

def deleteDeployDir() {
    sh "sudo rm -r $DIR/deploysapi*"
}

def deleteWorkspace() {
    sh "sudo rm -rf ${workspace}_ws-*"
}
