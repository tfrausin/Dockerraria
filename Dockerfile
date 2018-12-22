FROM ubuntu:18.04

ARG TERRARIA_VERSION='1.3.5.2'
ARG TMODLOADER_VERSION='0.10.1.5'

WORKDIR /terraria

ADD dconf .
ADD mods meta/mods
ADD worlds meta/worlds

RUN apt-get -qq update \
    && apt-get -qq -y upgrade \
    && apt-get -qq -y install wget unzip \
    && apt-get -y clean \
    && wget http://terraria.org/server/terraria-server-$(echo "$TERRARIA_VERSION" | sed -e 's/\.//g').zip \
    && unzip -qq -d . terraria-server-*.zip \
    && rm -rf Windows Mac terraria-server-*.zip \
    && wget -P Linux https://github.com/blushiemagic/tModLoader/releases/download/v$TMODLOADER_VERSION/tModLoader.Linux.v$TMODLOADER_VERSION.zip \
    && unzip -qq -d Linux Linux/tModLoader.Linux.v*.zip \
    && cp -a Linux/. . \
    && rm -rf Linux tModLoader.Linux.v*.zip \
    && chmod u+x tModLoaderServer*

EXPOSE 7777

CMD ./tModLoaderServer -config dconf