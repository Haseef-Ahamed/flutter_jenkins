pipeline {
    agent any
    environment {
        FLUTTER_HOME = "${env.WORKSPACE}/flutter"
        ANDROID_HOME = '/opt/android-sdk' // change if your sdk path differs
        PATH = "${env.FLUTTER_HOME}/bin:${env.ANDROID_HOME}/tools:${env.ANDROID_HOME}/platform-tools:${env.PATH}"
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
        stage('Install Dependencies') {
            steps {
                sh 'flutter pub get'
            }
        }
        stage('Print PATH') {
            steps {
                sh 'echo $PATH'
            }
        }
        stage('Code Analysis') {
            steps {
                sh 'flutter analyze'
            }
        }
        stage('Run Tests') {
            steps {
                sh 'flutter test'
            }
        }
        stage('Build Android APK') {
            steps {
                sh 'flutter build apk --release'
            }
        }
    }
    post {
        success {
            archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-release.apk', fingerprint: true
            emailext(subject: "CI Success: APK built (#${env.BUILD_NUMBER})", 
                     body: "Build and tests passed. The APK is archived.", 
                     to: 'mshaseefat@gmail.com')
        }
        failure {
            emailext(subject: "CI Failed (#${env.BUILD_NUMBER})", 
                     body: "Build or test failed. See Jenkins logs for details.", 
                     to: 'mshaseefat@gmail.com')
        }
    }
}
