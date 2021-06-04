FROM quay.io/centos/centos:centos7
ENV container=docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum makecache fast \
    && yum --disableplugin=fastestmirror -y install epel-release \
    && yum --disableplugin=fastestmirror -y install \
    bash \
    deltarpm \
    e2fsprogs \
    initscripts \
    sudo \
    cronie \
    pytho3 \
    python3-pip \
    which \
    unzip \
    yum-plugin-ovl \
    && yum -y update \
    && rm -rf /var/cache/yum

RUN pip3 install -U pip \
    && pip3 install ansible-core q

RUN sed -i 's/Defaults    requiretty/Defaults    !requiretty/g' /etc/sudoers

RUN echo '# BLANK FSTAB' > /etc/fstab

VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/lib/systemd/systemd"]
