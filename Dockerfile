FROM java:7

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		ca-certificates curl wget apt-transport-https libsnappy-dev libssl-dev libbz2-dev python-dev python-pip \
	&& rm -rf /var/lib/apt/lists/* \
	&& apt-get clean

# Copy over uber-JAR Secor
COPY build/libs/*.jar /opt/secor/secor.jar
COPY *.properties /opt/secor/

# Hadoop
RUN curl -s http://www.eu.apache.org/dist/hadoop/common/hadoop-2.7.1/hadoop-2.7.1.tar.gz | tar -xz -C /usr/local/
RUN ln -s /usr/local/hadoop-2.7.1 /usr/local/hadoop

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/hadoop/lib/native
ENV PATH $PATH:/usr/local/hadoop/bin

RUN pip install --upgrade awscli

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

# used for temp-files that are uploaded
VOLUME /tmp
