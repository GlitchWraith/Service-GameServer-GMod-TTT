FROM ubuntu:latest

ENV collection=1780079141
ARG steamAPIKey

RUN useradd -m steam
RUN apt-get update && apt-get install -y --no-install-recommends lib32gcc1 wget gdb gcc-multilib expect
RUN apt-get install --reinstall ca-certificates -y
RUN apt-get upgrade -y

RUN mkdir -p /home/Steam
RUN chown steam:steam /home/steam
USER steam
RUN mkdir -pv /home/steam/steamcmd
WORKDIR /home/steam/steamcmd
RUN wget http://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
RUN tar -xvzf steamcmd_linux.tar.gz && rm steamcmd_linux.tar.gz
RUN ./steamcmd.sh +quit

RUN ./steamcmd.sh +login anonymous +force_install_dir ../Server1 +app_update 4020 validate +quit
#RUN ./steamcmd.sh +login anonymous +force_install_dir ../content/tf2 +app_update 232250 validate +quit

COPY server.cfg ../Server1/garrysmod/cfg/server.cfg
COPY buildWorkAround.sh ../buildWorkAround.sh 

EXPOSE 27015/tcp
EXPOSE 27015/udp

EXPOSE 27005/tcp
EXPOSE 27005/udp

RUN /home/steam/buildWorkAround.sh $collection $steamAPIKey
# Rerun to prevent IO Errors
RUN /home/steam/buildWorkAround.sh $collection $steamAPIKey

ENV liveAPIKey = Nothing
ENTRYPOINT [ "/bin/bash", "-c", "/home/steam/Server1/srcds_run -game garrysmod +maxplayers 12 +map gm_flatgrass +ga memode terrortown -console +host_workshop_collection $collection -authkey $liveAPIKey -debug" ]
