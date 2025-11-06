pipeline {
    agent any
    stages {
        stage('Checkout') { steps { checkout scm } }
        stage('Dependencies') { steps { sh 'flutter pub get' } }
        stage('Analyze') { steps { sh 'flutter analyze' } }
        stage('Test') { steps { sh 'flutter test' } }
        stage('Build Android APK') { steps { sh 'flutter build apk --release' } }
        // Optionally add iOS analysis/testing here
    }
    post {
        success {
            archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-release.apk', fingerprint: true
            emailext(subject: "CI Success: Build #${env.BUILD_NUMBER}", body: "All checks passed.", to: 'mshaseefat@gmail.com')
        }
        failure {
            emailext(subject: "CI Failed", body: "Build failed. See Jenkins logs.", to: 'mshaseefat@gmail.com')
        }
    }
}
