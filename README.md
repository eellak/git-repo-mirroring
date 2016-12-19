GitHub repo mirroring script
=========

This is a script we use to mirror some GitHub repositories. It is written for
our use and is not usable for any other purpose without further development.

Usage
-------

Initialise the mirror repo.

github_mirror_init.sh ${domain of git server} ${initial organisation} ${repo name} ${destination organisation} ${github api token}

Example:

github_mirror_init.sh github.com my_org my-repo my_dest_org tHisISmyGITHubToKeN


Syncronise mirror with original repo.

github_mirror_sync.sh >> ${absolute path of log file} 2>&1


License
-------

MIT

Author Information
------------------

https://gfoss.ellak.gr (`sysadmin@ellak.gr`)
