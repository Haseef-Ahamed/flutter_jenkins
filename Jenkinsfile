pipeline {
    agent any
    environment {
        FLUTTER_HOME = "${env.WORKSPACE}/flutter"
        PATH = "${env.FLUTTER_HOME}/bin:${env.PATH}"
    }
    stages {
        stage('Install Flutter SDK') {
            steps {
                sh '''
                if [ ! -d "flutter" ]; then
                  git clone https://github.com/flutter/flutter.git -b stable flutter
                fi
                ${WORKSPACE}/flutter/bin/flutter doctor
                '''
            }
        }
        stage('Dependencies') {
            steps { sh 'flutter pub get' }
        }
        stage('Analyze') {
            steps { sh 'flutter analyze' }
        }
        stage('Test') {
            steps { sh 'flutter test' }
        }
        stage('Build Android APK') {
            steps { sh 'flutter build apk --release' }
        }
    }
    post {
        success {
            archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-release.apk', fingerprint: true
            emailext(subject: "CI Success: APK built", body: "Build/test succeeded.", to: 'mshaseefat@gmail.com')
        }
        failure {
            emailext(subject: "CI Failed", body: "See Jenkins logs.", to: 'mshaseefat@gmail.com')
        }
    }
}
