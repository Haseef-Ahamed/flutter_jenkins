pipeline {
    agent any
    environment {
        FLUTTER_HOME = "${env.WORKSPACE}/flutter"
        ANDROID_HOME = '/opt/android-sdk' // change if your sdk path differs
        PATH = "${env.FLUTTER_HOME}/bin:${env.ANDROID_HOME}/tools:${env.ANDROID_HOME}/platform-tools:${env.PATH}"
    }
    stages {
        stage('Install wget & unzip') {
        steps {
            sh 'apt-get update && apt-get install -y wget unzip'
            }
        }
        stage('Install Android SDK') {
        steps {
            sh '''
            if [ ! -d "$ANDROID_HOME" ]; then
            mkdir -p "$ANDROID_HOME"
            cd "$ANDROID_HOME"
            wget https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip -O cmdline-tools.zip
            unzip cmdline-tools.zip
            mkdir -p cmdline-tools
            mv cmdline-tools cmdline-tools/latest
            fi
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
