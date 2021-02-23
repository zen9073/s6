# zen9073/s6
FROM ubuntu:20.04 

# 中国时区
ENV TZ=Asia/Shanghai

# 安装工具和程序依赖
RUN set -x \
    && cp -a /etc/apt/sources.list /etc/apt/sources.list.bak \
    && sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list \
    && sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl htop netcat net-tools tzdata vim wget \
    && apt-get clean \
    && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# vimrc
RUN set -x \
    && echo >> ~/.vimrc "syntax on" \
    && echo >> ~/.vimrc "hi Comment ctermfg=6" \
    && echo >> ~/.vimrc "let loaded_matchparen=1" \
    && echo >> ~/.vimrc "set encoding=utf-8" \
    && echo >> ~/.vimrc "set tabstop=4" \
    && echo >> ~/.vimrc "set softtabstop=4" \
    && echo >> ~/.vimrc "set expandtab" \
    && echo >> ~/.vimrc "set ruler" \
    && echo >> ~/.vimrc "set showcmd" \
    && echo >> ~/.vimrc "set showmatch" \
    && echo >> ~/.vimrc "set hlsearch" \
    && echo >> ~/.vimrc "set incsearch"

# 安装 s6 overlay
ENV S6_OVERLAY_RELEASE=https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-amd64.tar.gz
RUN set -x \
    && wget -O /tmp/s6-overlay-amd64.tar.gz ${S6_OVERLAY_RELEASE}  \
    && tar xf /tmp/s6-overlay-amd64.tar.gz -C / --exclude="./bin" \
    && tar xf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin \
    && rm -f /tmp/s6-overlay-amd64.tar.gz

# root filesystem
COPY rootfs /

ENTRYPOINT ["/init"]
