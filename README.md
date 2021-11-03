# mg
# Modemguard

To set up the local repository, install git, then from the Git CMD:
1. `mkdir mg`
1. `cd mg`
1. `git init`
1. `git remote add origin https://github.com/jdabbs003/mg.git`
1. `git pull origin main`

## installing modemguard

To install modemguard on a Teltonika router, execute these lines from the shell. Do this at your own risk. Seriously.
1. `wget https://github.com/jdabbs003/mg/blob/main/mg_install?raw=true`
1. `chmod 777 mg_install`
3. `./mg_install`

## using modemguard

Modemguard runs as a daemon on a Teltonika router, disabling the LTE modem while the primary WAN is
working, and enabling the LTE modem when the primary WAN fails. It determines WAN health by pinging
a remote IP. Once installed, Modemguard is controlled by these four basic commands:

Command | Fuction
------- | -------
`/etc/init.d/mgd start` | Starts the modemguard daemon.
`/etc/init.d/mgd stop` | Stops the modemguard daemon.
`/etc/init.d/mgd enable` | Enablies the modemguard daemon to run at boot.
`/etc/init.d/mgd disable` | Disables the modemguard daemon from running at boot.
