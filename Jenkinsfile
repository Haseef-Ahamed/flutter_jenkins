pipeline {
    agent any
    environment {
        // Set these according to your actual install paths in the Docker image
        FLUTTER_HOME = "/opt/flutter"       // e.g. '/opt/flutter' if that's where you installed it
        ANDROID_HOME = "/opt/android-sdk"   // e.g. '/opt/android-sdk' if that's your SDK root
        PATH = "${FLUTTER_HOME}/bin:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}"
    }
    stages {
        stage('Print Tool Versions') {
            steps {
                sh '''
                echo "Flutter version:"; flutter --version || echo "NO FLUTTER FOUND"
                echo "Java version:"; java -version || echo "NO JAVA FOUND"
                echo "Android SDK location:"; ls -l $ANDROID_HOME || echo "NO ANDROID SDK FOUND"
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
