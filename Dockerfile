FROM peelvalley/ubuntu-python

RUN apt-get update && apt-get install -y sudo nano tmux less mbuffer libass9 libvpx5 libfdk-aac1 libmp3lame0 libopus0 libvorbis0a libvorbisenc2 libx264-152 libx265-146
RUN pip install streamlink youtube-dl
COPY --from=phillmac/mkvserver_mk2-build /root/mkvserver_mk2/mkv_server /root/bin/* /usr/local/bin/

RUN  adduser --disabled-password --gecos "" user

WORKDIR /home/user

COPY scripts scripts
COPY functions functions

WORKDIR /home/user/scripts
RUN chmod -v a+x *.sh *.py \
 && usermod -aG video user

#streamlink issues warnings if run as root
USER user
RUN echo 'source ${HOME}/scripts/load_functions.sh' >> "${HOME}/.bashrc"
