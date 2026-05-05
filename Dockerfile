FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependências necessárias
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa openjdk-17-jdk wget

# Configurar Android SDK
ENV ANDROID_HOME="/usr/local/android-sdk"
RUN mkdir -p $ANDROID_HOME/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O sdk.zip && \
    unzip sdk.zip -d $ANDROID_HOME/cmdline-tools && \
    mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest && \
    rm sdk.zip

ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools
RUN yes | sdkmanager --licenses
RUN sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Instalar Flutter
RUN git clone -b stable https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH=$PATH:/usr/local/flutter/bin
RUN flutter doctor

WORKDIR /app
COPY . .

# Rodar o build
RUN flutter pub get
RUN flutter build apk --release