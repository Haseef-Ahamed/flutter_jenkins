FROM jenkins/jenkins:lts-jdk21
USER root
# Install dependencies
RUN apt-get update \
 && apt-get install -y wget unzip git curl xz-utils libglu1-mesa \
 && rm -rf /var/lib/apt/lists/*
# Install Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable /opt/flutter
ENV PATH="/opt/flutter/bin:$PATH"
# Install Android SDK Command Line Tools
RUN mkdir -p /opt/android-sdk/cmdline-tools && \
    cd /opt/android-sdk && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip -O cmdline-tools.zip && \
    unzip cmdline-tools.zip -d /opt/android-sdk/cmdline-tools && \
    mv /opt/android-sdk/cmdline-tools/cmdline-tools /opt/android-sdk/cmdline-tools/latest && \
    rm cmdline-tools.zip
ENV ANDROID_HOME="/opt/android-sdk"
ENV PATH="/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:$PATH"
# Accept Android licenses and install core components
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
RUN chown -R jenkins:jenkins /opt/flutter
USER jenkins
