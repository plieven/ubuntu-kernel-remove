# ubuntu-kernel-remove

Automatical tool to remove unneeded kernels from the system. Has some additional skills like keeping one version of each kernel train, keeping running kernel, integrate with cron-apt and much more.

Call install.sh to integrate automatically with your system to remove unneeded kernels at boottime and run after cron-apt has run.

ubuntu-kernel-remove has the following cmdline args:
* -a automatically run and remove old kernels
* -s log to syslog and stdout/err (default is stdout/err only)
* -1 keep only one kernel if possible
 
Use at your own risk!
