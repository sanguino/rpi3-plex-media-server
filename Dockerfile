FROM resin/rpi-raspbian:jessie

# Dependencies
RUN sudo apt-get update && sudo apt-get upgrade -y
RUN sudo apt-get upgrade && sudo apt-get dist-upgrade
RUN sudo apt-get install apt-transport-https -y --force-yes

# Install Plex
RUN wget -O - https://dev2day.de/pms/dev2day-pms.gpg.key  | sudo apt-key add -
RUN echo "deb https://dev2day.de/pms/ jessie main" | sudo tee /etc/apt/sources.list.d/pms.list
RUN sudo apt-get update
RUN sudo apt-get install -t jessie plexmediaserver -y

# Setup volumes
#  - /config holds the server settings
#  - /data is where media should be mounted
VOLUME ["/config", "/data"]

# Plex config environment vars
ENV HOME=/config

# Plex server port
EXPOSE 32400

# Add a line to the Plex start.sh script to remove any
# previous pid file found in the config dir. Plex wont
# start if this file is left over from a previous run.
RUN sed -i '2i rm -rf /config/Library/Application\\ Support/Plex\\ Media\\ Server/plexmediaserver.pid' ${PLEX_PATH}/start.sh

WORKDIR ${PLEX_PATH}
CMD ["bash", "start.sh"]
