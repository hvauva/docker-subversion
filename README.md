# Docker Subversion Server based on secured Apache SSL PHP on Ubuntu 14.04


## What is it

A Docker Subversion Apache2 Container (based on marvambass/subversion).

It gives you automatically daily dumps of your SVN Repos for your Backup.
Also you are able to create a new Project by just adding a new Folder to your repository root directory.

You can control the access of your Project with a htpasswd file in combination with a authz file.


## pre run configuration (optional)

You may create the following two files. If you don't need access control you can just skip this step.

Create authz file like this example: 

__$DAV_SVN_CONF/dav_svn.authz__

    [groups]
    admin = user1,user2, testuser
    devgroup = user5, user6

    [project1:/]
    @admin = rw
    @devgroup = r

    # devgroup members are able to read and write on project2
    [project2:/]
    @devgroup = rw
    
    # admins have control over every project - and can list all projects on the root point
    [/]
    @admin = rw

    # everybody is able to read repos and sees all projects
    [/]
    * = r
    

__$DAV_SVN_CONF/dav_svn.passwd__

To add a new User like 'testuser' with password 'test' use the following command

    htpasswd -c $DAV_SVN_CONF/dav_svn.passwd testuser

Or if you're to lazy, just use this line for your file (for testing only!)

    testuser:$apr1$A2fjdj5R$hx9HvwAuj.i5niRjHEMnA.

## Run the container

    docker run \
    -d \
    -v $SVN:/var/local/svn \
    -v $SVN_BACKUP:/var/svn-backup \
    -v $DAV_SVN_CONF/:/etc/apache2/dav_svn/ \
    --name subversion marvambass/subversion \