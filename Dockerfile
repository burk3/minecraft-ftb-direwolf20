# minecraft-ftb-direwolf20
# 
# VERSION	1.0

FROM ubuntu:16.04
MAINTAINER burk3 <burke.cates@gmail.com>

LABEL Description="FTB Minecraft server with the Direwolf20 pack" Vendor="Xadozuk" Version="1.0"

ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_VERSION 8

ENV SERVER_PACK_URL http://www.creeperrepo.net/FTB2/modpacks%5Edirewolf20_17%5E1_10_0%5Edirewolf20_17-server.zip
ENV SERVER_FILE_NAME minecraft-server.zip

ENV FTB_JAVA_PARAMS="-Xms512M -Xmx2048M -XX:PermSize=256M -XX:+UseParNewGC -XX:+CMSIncrementalPacing -XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2 -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10"

# Install unzip utility
RUN apt-get -y update
RUN apt-get install -y software-properties-common \
			&& add-apt-repository -y ppa:webupd8team/java \
			&& apt-get update \
			&& echo oracle-java${JAVA_VERSION}-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
			&& apt-get install -y oracle-java${JAVA_VERSION}-installer ca-certificates
RUN apt-get install -y unzip
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create minecraft folders
RUN useradd -M -s /bin/false minecraft && \
    mkdir -p /minecraft/world && \
    chown -R minecraft:minecraft /minecraft

WORKDIR /minecraft

USER minecraft

# Download and extract minecraft files
RUN wget -O ${SERVER_FILE_NAME} ${SERVER_PACK_URL} && \
    unzip ${SERVER_FILE_NAME} -d . && \
    rm -f ${SERVER_FILE_NAME} && \
    chmod +x ServerStart.sh

# Accept eula
RUN sed -i -e 's/false/true/' eula.txt

# Allow Java params from env
RUN sed -i -e 's/-server .* -jar \(FTBServer-.*\.jar\) nogui/-server $FTB_JAVA_PARAMS -jar \1 nogui/' ServerStart.sh

# Minecraft server port
EXPOSE 25565

VOLUME ["/minecraft/world"]

# Start minecraft server
CMD ["./ServerStart.sh"]

