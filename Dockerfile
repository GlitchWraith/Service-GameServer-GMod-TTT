FROM ghostlink/service-gameserver-gmod:latest

ENV collection=2035305813

COPY server.cfg /Steam/Gmod/garrysmod/cfg/server.cfg
COPY buildWorkAround.sh /Steam/buildWorkAround.sh 

EXPOSE 27015/tcp
EXPOSE 27015/udp

EXPOSE 27005/tcp
EXPOSE 27005/udp

RUN /Steam/buildWorkAround.sh /Steam/Gmod/srcds_run  $collection 
# Rerun to prevent IO Errors
RUN /Steam/buildWorkAround.sh /Steam/Gmod/srcds_run  $collection 

COPY config.txt /Steam/Gmod/garrysmod/data/mapvote/config.txt 

ENV map = ttt_lego
ENTRYPOINT [ "/bin/bash", "-c", "/Steam/Gmod/srcds_run  -game garrysmod +maxplayers 12 +map $map +gamemode terrortown -console +host_workshop_collection $collection -debug" ]
