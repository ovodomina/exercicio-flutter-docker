# Estágio de construção
FROM ubuntu:22.04

# Evita interações durante a instalação
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependências essenciais do sistema
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa openjdk-17-jdk wget clang cmake ninja-build pkg-config libgtk-3-dev

# Configurar diretórios do Android SDK
ENV ANDROID_HOME="/usr/local/android-sdk"
RUN mkdir -p $ANDROID_HOME/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O sdk.zip && \
    unzip sdk.zip -d $ANDROID_HOME/cmdline-tools && \
    mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest && \
    rm sdk.zip

# Configurar Variáveis de Ambiente do Android
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/34.0.0

# Aceitar licenças e instalar componentes do Android SDK
RUN yes | sdkmanager --licenses
RUN sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Instalar Flutter (Versão Estável)
RUN git clone -b stable https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH=$PATH:/usr/local/flutter/bin

# Habilitar suporte para Android e aceitar licenças do Flutter
RUN flutter config --no-analytics && \
    flutter doctor --android-licenses && \
    flutter doctor

# Configurar diretório de trabalho
WORKDIR /app

# Copiar os arquivos do projeto (pubspec.yaml e pasta lib)
COPY . .

# --- RESOLUÇÃO DO ERRO ---
# 1. Baixa as dependências do Dart/Flutter
RUN flutter pub get

# 2. Reconstrói a pasta /android que estava faltando
# Isso cria o Gradle, o Manifest e as configurações nativas necessárias
RUN flutter create . --platforms android

# 3. Executa o build do APK (Release)
RUN flutter build apk --release

# O APK final estará em: /app/build/app/outputs/flutter-apk/app-release.apk