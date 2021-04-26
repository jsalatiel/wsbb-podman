FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER_UID=1000
ENV USER_GID=1000
ENV USERNAME=user

#    sudo gosu \

RUN ln -sf /bin/true /usr/bin/chfn && apt-get update && apt-get install -y \
    libnss3-tools \
    zenity \
    libgtk2.0-0 \
    dbus-x11 \
    yad \
    libcurl3 \
    libdbus-1.3 \
    libxss1 \
    lsb-release \
    net-tools \
    openssl \
    firefox \
    systemd  \
    systemd-sysv


ADD https://cloud.gastecnologia.com.br/cef/warsaw/install/GBPCEFwr64.deb /src/warsaw.deb
RUN groupadd -g ${USER_GID} user && useradd -u ${USER_UID} -g ${USER_GID} -ms /bin/bash user && chown -R user.user /home/user

#RUN dpkg -i /w.deb || exit 0

COPY context/firefox.service /etc/systemd/system/
COPY context/startbrowser.sh /usr/local/bin/

#	systemctl enable warsaw && \

RUN mkdir -p /var/run/dbus && \ 
	systemctl enable firefox && \
	systemctl disable systemd-resolved && systemctl disable systemd-tmpfiles-setup.service

STOPSIGNAL SIGRTMIN+3


ENTRYPOINT [ "/sbin/init" ]
