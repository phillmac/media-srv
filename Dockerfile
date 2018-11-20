FROM phillmac/python-ubuntu

RUN apt-get update && apt-get install -y sudo nano tmux less mbuffer libass9 libvpx5 libfdk-aac1 libmp3lame0 libopus0 libvorbis0a libvorbisenc2 libx264-152 libx265-146
RUN pip install streamlink
COPY --from=phillmac/mkvserver_mk2-build /root/mkvserver_mk2/mkv_server /root/bin/* /usr/local/bin/
COPY scripts/* /scripts/

#streamlink doesn't like root
RUN  chmod a+x /scripts/* && adduser --disabled-password --gecos "" user
USER user 

