FROM node:10

ARG RELEASE=4.2.0.1873
ARG TS=3.4.5

LABEL maintainer="Alexander Alexandrov <aalexandrovv@gmail.com>"

RUN apt-get update && apt-get -y install openjdk-8-jdk && \
    npm install -g typescript@${TS}

RUN java -version

ENV SONAR_RUNNER sonar-scanner-${RELEASE}-linux
ENV SONAR_RUNNER_HOME /opt/${SONAR_RUNNER}
ENV PATH ${PATH}:${SONAR_RUNNER_HOME}/bin

RUN set -x && \
    curl --insecure -o /tmp/sonarscanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${RELEASE}-linux.zip && \
    unzip /tmp/sonarscanner.zip ${SONAR_RUNNER}/bin/* ${SONAR_RUNNER}/lib/* ${SONAR_RUNNER}/conf/* -d /tmp && \
    rm /tmp/sonarscanner.zip && \
    mkdir -p ${SONAR_RUNNER_HOME} && \
    mv -v /tmp/${SONAR_RUNNER} /opt

RUN sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' $(which sonar-scanner)

RUN sonar-scanner --version

CMD ["sh"]
