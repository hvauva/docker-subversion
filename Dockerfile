FROM marvambass/apache2-ssl-php

MAINTAINER MarvAmBass

ENV LANG C.UTF-8

ENV SVN_REPO master
ENV SVN_ROOT /var/local/svn
ENV SVN_BACKUP /var/svn-backup
ENV DAV_SVN_CONF /etc/apache2/dav_svn

RUN apt-get update && apt-get install -y \
    subversion \
    libapache2-svn \
    apache2-mpm-prefork

RUN a2enmod dav_svn
RUN a2enmod auth_digest

#RUN mkdir /var/svn-backup
#RUN mkdir -p /var/local/svn
#RUN mkdir /etc/apache2/dav_svn

RUN mkdir $SVN_BACKUP
RUN mkdir -p $SVN_ROOT
RUN mkdir $DAV_SVN_CONF

ADD files/dav_svn.conf /etc/apache2/mods-available/dav_svn.conf

ADD files/svn-backuper.sh /usr/local/bin/
ADD files/svn-project-creator.sh /usr/local/bin/
ADD files/svn-entrypoint.sh /usr/local/bin/

RUN chmod a+x /usr/local/bin/svn*

RUN echo "*/10 * * * *	root    /usr/local/bin/svn-project-creator.sh" >> /etc/crontab
RUN echo "0 0 * * *	root    /usr/local/bin/svn-backuper.sh" >> /etc/crontab

RUN sed -i 's/# exec CMD/&\nsvn-entrypoint.sh/g' /opt/entrypoint.sh

RUN svnadmin create $SVN_ROOT/$SVN_REPO
