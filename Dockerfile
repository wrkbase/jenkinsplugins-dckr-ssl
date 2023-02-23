FROM jenkins/jenkins:latest


USER root

ENV httpPort 8080
ENV httpsPort 8443
ENV httpsKeyStore /jenkins_keystore.jks
ENV httpsKeyStorePassword Admin@123
ENV JENKINS_USER admin
ENV JENKINS_PASS Admin@123
ENV JAVA_OPTS "-Xmx2048m -Dhudson.slaves.NodeProvisioner.MARGIN=50 -Dhudson.slaves.NodeProvisioner.MARGIN0=0.85 -Dhudson.slaves.SlaveComputer.allowUnsupportedRemotingVersions=true -Djenkins.install.runSetupWizard=false -Duser.timezone=CET"
ENV JENKINS_OPTS "--httpPort=8080 --httpsPort=8443 --httpsKeyStore=/var/lib/store/jenkins.jks --httpsKeyStorePassword=Admin@123"

RUN apt-get update -y && apt-get install -y openjdk-11-jdk
RUN openssl genrsa -out jenkins.key 4096 && openssl req -new -key jenkins.key -out jenkins.csr -subj "/C=US/ST=Example/L=Example/O=Example Company Inc./CN=www.example.com" && openssl x509 -req -days 3560 -in jenkins.csr -signkey jenkins.key -out jenkins.pem && openssl pkcs12 -inkey ./jenkins.key -in ./jenkins.pem  -export -out keys.pkcs12 -password pass:Admin@123 && keytool -importkeystore -noprompt -srckeystore keys.pkcs12 -srcstoretype pkcs12 -destkeystore jenkins.jks -srcstorepass Admin@123 -deststorepass Admin@123 && rm -f jenkins.csr jenkins.key  jenkins.pem  keys.pkcs12 && mkdir -p /var/lib/store && chmod 755 jenkins.jks && cp -f ./jenkins.jks /var/lib/store/jenkins.jks
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /bin/jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/default-user.groovy
