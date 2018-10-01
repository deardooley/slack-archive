# Slack Dump and Archive

> Adapted from [https://github.com/singularityware/singularity-slack]()

This is a simple script to export slack history from the Agave community slack channel. This should be run daily via 
cron or other service to ensure daily backups are in place.  

# Prerequisites

The primary code in this project is the [slack-history-export](https://www.npmjs.com/package/slack-history-export) 
node module. So, node and npm are requirements. If running as a Docker image, Docker and Docker Compose are required
as well. 


# Running

Running natively just requires the installation of the `slack-history-export` module and execution fo the `export_slack.sh` script.   

```bash
# install the module
npm i -g slack-history-export  

# add the crontab entry
echo "00 00 * * * /bin/bash $PWD/export_slack.sh" >> slackexport 
crontab slackexport

# Verify the cron entry was added
crontab -l
```

You can also run this as a docker container using the included Docker Compose file. This will mount the project `.git` 
folder into the container to enable pushing the update to the remote system.   

```bash
# add the crontab entry
echo "00 00 * * * /bin/bash $PWD/export_slack.sh" >> slackexport 
crontab slackexport
```

You need to set your `SLACK_KEY` with a valid [legacy Slack token](https://api.slack.com/custom-integrations/legacy-tokens)
as well as `SSH_PRIVATE_KEY` with the path to the git deployment key used to commit the backup to your forked repository. 
By default, it will use the default ssh key for the container user, `$HOME/.ssh/id_rsa` 