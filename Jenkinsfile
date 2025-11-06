pipeline {
    agent any
    environment {
        FLUTTER_HOME = "/opt/flutter"
        ANDROID_HOME = "/opt/android-sdk"
        PATH = "${FLUTTER_HOME}/bin:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}"
    }
    stages {
        stage('Show Tool Versions & Paths') {
            steps {
                sh '''
                echo "Flutter version:"
                flutter --version
                echo "Java version:"
                java -version
                echo "Android SDK location:"
                ls -l $ANDROID_HOME
                echo "PATH: $PATH"
                '''
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'flutter pub get'
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
