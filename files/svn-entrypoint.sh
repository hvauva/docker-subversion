#!/bin/bash

cat <<EOF
Version 1.0.4


To use this container you can add a volume for $DAV_SVN_CONF
which includes the following 2 files:

dav_svn.authz
   a authz file to control the access to your subversion repositories

dav_svn.passwd
   a htpasswd file to manage the users for this subversion system
   
There will be also daily backups of the subversion projects stored under

$SVN_BACKUP

The actuall SVN Data is stored in the Volume beneath

$SVN_ROOT
EOF

if [ ! -f $DAV_SVN_CONF/dav_svn.authz ]
then
    echo "generating dav_svn.authz file which disables user protection"
    cat <<EOF > $DAV_SVN_CONF/dav_svn.authz
# disable protection - everybody can do what he wants
[/]
* = rw
EOF
fi

if [ ! -f $DAV_SVN_CONF/dav_svn.passwd ]
then
    echo "generating empty htpasswd file for svn users"
    echo "# no users in this htpasswd file" > $DAV_SVN_CONF/dav_svn.passwd
fi

chown -R www-data:www-data "/var/local/svn/"
cron -f &
