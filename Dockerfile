FROM ghostlink/service-gameserver-gmod:latest

ENV collection=1780079141

ARG steamAPIKey

COPY server.cfg ../Server1/garrysmod/cfg/server.cfg
COPY buildWorkAround.sh ../buildWorkAround.sh 

EXPOSE 27015/tcp
EXPOSE 27015/udp

EXPOSE 27005/tcp
EXPOSE 27005/udp

RUN /home/steam/buildWorkAround.sh $collection $steamAPIKey
# Rerun to prevent IO Errors
RUN /home/steam/buildWorkAround.sh $collection $steamAPIKey

ENV map = ttt_lego
ENV liveAPIKey = Nothing
ENTRYPOINT [ "/bin/bash", "-c", "/home/steam/Server1/srcds_run -game garrysmod +maxplayers 12 +map $map +gamemode terrortown -console +host_workshop_collection $collection -authkey $liveAPIKey -debug" ]
