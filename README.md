# media-srv
Ffmpeg, streamlink and other utils for streaming and ripping

# Build instructions:
```bash
ubuntu_version="18.04"
ffmpeg_version="tags/n4.1"

docker build \
    -t phillmac/ffmpeg-build:${ubuntu_version}-${ffmpeg_version////_} \
    --build-arg FFMPEG_VERSION=${ffmpeg_version} \
    --target ffmpeg_builder \
    git://github.com/phillmac/ffmpeg-build#${ubuntu_version}

docker build \
    -t phillmac/mkvserver_mk2-build \
    --target mkvserver_mk2_builder \
    git://github.com/phillmac/mkvserver_mk2-build

docker build \
    -t phillmac/python-ubuntu:18.04-3.7.1 \
    -t phillmac/python-ubuntu:18.04-3.7 \
    -t phillmac/python-ubuntu \
    git://github.com/phillmac/docker-python-ubuntu#18.04-3.7.1
    
docker build \
    -t phillmac/media-srv \
    git://github.com/phillmac/media-srv
```
# Example docker-compose.yml:

```
version: "3.6"

services:
  media-srv-monstercat:
    image: phillmac/media-srv
    restart: unless-stopped
    network_mode: host
    tmpfs:
    - /tmp
    volumes:
      - /dev/shm/hls:/dev/shm/hls
      - media-srv-monstercat-user:/home/user
    tty: true
    environment:
      streamlink_url: twitch.tv/monstercat
      streamlink_quality: best
      ffmpeg_hls_list_size: 20
      ffmpeg_hls_seg_leng: 15
      ffmpeg_hls_out: /dev/shm/hls/monstercat/monstercat.m3u8
      ffmpeg_ice_name: Monstercat Radio
      ffmpeg_ice_description: Monstercat Radio - 24/7 Music Stream - monster.cat/Spotify-Playlists
      ffmpeg_ice_url: https://twitch.tv/monstercat
      ffmpeg_ice_genre: Various
      ffmpeg_icecast_out: icecast://source:hackme@localhost:8000/monstercat
      ffmpeg_av_ice_name: Monstercat Radio
      ffmpeg_av_ice_description: Monstercat Radio - 24/7 Music Stream - monster.cat/Spotify-Playlists
      ffmpeg_av_ice_url: https://twitch.tv/monstercat
      ffmpeg_av_ice_genre: Various
      ffmpeg_av_icecast_out: icecast://source:hackme@localhost:8000/monstercat_av
      python_http_port: 8090
      python_http_root: /dev/shm/hls/monstercat
    command: ["bash", "-c", "source /home/user/run.sh && bash"]
  icecast:
    image: moul/icecast
    restart: unless-stopped
    ports:
      - "8000:8000/tcp"
    environment:
      ICECAST_SOURCE_PASSWORD: hackme
      ICECAST_ADMIN_PASSWORD: hackme
      ICECAST_RELAY_PASSWORD: hackme
```
**Don't forget to change the icecast passwords, especialy if you intentd to make your stream publicy available!!!**

# Example /home/user/run.sh
```bash
#!/bin/bash
source /load_functions.sh
rm -v /dev/shm/hls/monstercat/monstercat*.ts
tmux new -d -x 150 -y 50 bash -c "bash_repeat streamlink_hls_mkvserver_ice_av_out"
```
#View running process output:
`docker-compose exec media-srv-monstercat tmux attach -r`

#Outstanding Bugs and issues:
 - Most players expect icecast streams to be audio only, and will fail to detect the codecs properly. Workarrounds:
   - pipe output from wget to vlc e.g. `wget http://icecasturl:8000/stream -qO - | vlc -`
   
 
