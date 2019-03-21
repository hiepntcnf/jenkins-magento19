node {
    def PROJECT_NAME = "project_name"

    // Clean workspace before doing anything
    sh 'ls'
    deleteDir()

    propertiesData = [disableConcurrentBuilds()]
    if (isValidDeployBranch()) {
       propertiesData = propertiesData + parameters([
            choice(choices: 'none\nIGR\nPRD', description: 'Target server to deploy', name: 'deployServer'),
        ])
    }
    properties(propertiesData)

    try {
        stage ('Clone') {
            checkout scm
           
            
        }
        stage ('preparations') {
            try {
                deploySettings = getDeploySettings()
                echo 'Deploy settings were set'
            } catch(err) {
                println(err.getMessage());
                throw err
            }
        }
        withEnv(['PATH = "$PATH:/usr/local/bin"']) {
            stage('Build') {
                sh 'printenv'
            sh 'ls'
            sh "docker-compose build"
        }
            
    }
        
        stage ('Tests') {
            docker.image('canifa/php').inside {
            sh 'php --version'
        }
            parallel 'static': {
            },
            'unit': {
            },
            'integration': {
            }
        }
        if (deploySettings) {
            stage ('Deploy') {
                if (deploySettings.type && deploySettings.version) {
                    // Deploy specific version to a specifc server (IGR or PRD)
                    notifyDeployedVersion(deploySettings.version)
                } else {
                    // Deploy to develop branch into IGR server
                }
            }
        }
    } catch (err) {
        currentBuild.result = 'FAILED'
        notifyFailed()
        throw err
    }
}

def isValidDeployBranch() {
    branchDetails = getBranchDetails()
    if (branchDetails.type == 'hotfix' || branchDetails.type == 'release') {
        return true
    }
    return false
}

def getBranchDetails() {
    def branchDetails = [:]
    branchData = BRANCH_NAME.split('/')
    if (branchData.size() == 2) {
        branchDetails['type'] = branchData[0]
        branchDetails['version'] = branchData[1]
        return branchDetails
    }
    return branchDetails
}

def getDeploySettings() {
    def deploySettings = [:]
    if (BRANCH_NAME == 'develop') { 
        deploySettings['ssh'] = "user@domain-igr.com"
    } else if (params.deployServer && params.deployServer != 'none') {
        branchDetails = getBranchDetails()
        deploySettings['type'] = branchDetails.type
        deploySettings['version'] = branchDetails.version
        if (params.deployServer == 'PRD') {
            deploySettings['ssh'] = "user@domain-prd.com"
        } else if (params.deployServer == 'IGR') {
            deploySettings['ssh'] = "user@domain-igr.com"
        }
    }
    return deploySettings
}

def notifyDeployedVersion(String version) {
  emailext (
      subject: "Deployed: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
      body: "DEPLOYED VERSION '${version}': Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]': Check console output at '${env.BUILD_URL}' [${env.BUILD_NUMBER}]",
      to: "some-email@some-domain.com"
    )
}

def notifyFailed() {
  emailext (
      subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
      body: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]': Check console output at '${env.BUILD_URL}' [${env.BUILD_NUMBER}]",
      to: "some-email@some-domain.com"
    )
}
