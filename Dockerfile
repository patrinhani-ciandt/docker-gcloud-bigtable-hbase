FROM google/debian:wheezy
ENV DEBIAN_FRONTEND noninteractive

ENV JAVA_VERSION 7u79
ENV JAVA_DEBIAN_VERSION 7u79-2.5.5-1~deb8u1

RUN apt-get update \
        && apt-get install -y -qq --no-install-recommends \ 
        wget \
        curl \
        unzip \
        python \
        php5-mysql \
        php5-cli \
        php5-cgi \
        openjdk-7-jre \
        openssh-client \
        python-openssl \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

# Begin - Google Cloud SDK

RUN wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.zip && unzip google-cloud-sdk.zip && rm google-cloud-sdk.zip
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1
RUN google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --disable-installation-options
RUN google-cloud-sdk/bin/gcloud --quiet components update pkg-go pkg-python pkg-java preview alpha beta app
RUN google-cloud-sdk/bin/gcloud --quiet config set component_manager/disable_update_check true
RUN mkdir /.ssh
ENV PATH /google-cloud-sdk/bin:$PATH
ENV HOME /
VOLUME ["/.config"]
CMD ["/bin/bash"]

# End - Google Cloud SDK

# Begin - Java openjdk-7-jdk

ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/

# End - Java openjdk-7-jdk

# Begin - HBase Client

ENV GOOGLE_APPLICATION_CREDENTIALS=/hbase/conf/key.json

WORKDIR /

RUN mkdir hbase 
RUN curl http://storage.googleapis.com/cloud-bigtable/hbase-dist/hbase-1.0.1/hbase-1.0.1-bin.tar.gz \
        | tar -zxC hbase --strip-components=1

RUN mkdir -p hbase/lib/bigtable
RUN curl -0 https://storage.googleapis.com/cloud-bigtable/jars/bigtable-hbase/bigtable-hbase-1.0-0.1.9-shaded.jar  \
        -o /hbase/lib/bigtable/bigtable-hbase-0.1.9.jar
RUN curl -0 http://central.maven.org/maven2/org/mortbay/jetty/alpn/alpn-boot/7.1.3.v20150130/alpn-boot-7.1.3.v20150130.jar \
        -o /hbase/lib/bigtable/alpn-boot-7.1.3.v20150130.jar

RUN echo "export HBASE_CLASSPATH=/hbase/lib/bigtable/bigtable-hbase-0.1.9.jar" >>/hbase/conf/hbase-env.sh && \
    echo "export HBASE_OPTS=\"${HBASE_OPTS} -Xms1024m -Xmx2048m -Xbootclasspath/p:/hbase/lib/bigtable/alpn-boot-7.1.3.v20150130.jar\""  >>/hbase/conf/hbase-env.sh

ADD . /hbase/conf

ENV PATH /hbase/bin:$PATH

# End - HBase Client
