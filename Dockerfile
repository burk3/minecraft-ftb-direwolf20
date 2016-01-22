# minecraft-ftb-direwolf20
# 
# VERSION	1.0

FROM xadozuk/ubuntu-java:latest
MAINTAINER Xadozuk <docker@xadozuk.com>

LABEL Description="FTB Minecraft server with the Direwolf20 pack" Vendor="Xadozuk" Version="1.0"

ENV DEBIAN_FRONTEND noninteractive

ENV SERVER_PACK_URL http://www.creeperrepo.net/FTB2/modpacks%5Edirewolf20_17%5E1_10_0%5Edirewolf20_17-server.zip
ENV SERVER_FILE_NAME minecraft-server.zip

ENV FTB_JAVA_PARAMS="-Xms2048m -Xmx3072m -XX:PermSize=256m -XX:+UseParNewGC -XX:+UseConcMarkSweepGC"

# Install unzip utility
RUN apt-get update -y
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
RUN sed -i -e 's/^java -server .* -jar \(FTBServer-.*\.jar\) nogui$/java -server $FTB_JAVA_PARAMS -jar \1 nogui/' ServerStart.sh

# Minecraft server port
EXPOSE 25565

VOLUME ["/minecraft/world"]

# Start minecraft server
CMD ["./ServerStart.sh"]

