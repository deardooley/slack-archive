#!/usr/bin/env bash
# Make sure to install the node slack dependency before running
#
# npm install --global slack-history-export@1.1.0
#

# add all the channels you want to backup here
CHANNELS="general random"

# set to 1 to enable verbose output
verbose=1
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
((verbose)) && pwd
((verbose)) &&cd $DIR
((verbose)) &&whoami
((verbose)) &&pwd

echo "Running slack export of  $(date)"

if [ -z "$SLACK_KEY" ]; then
  ((verbose)) &&echo "No key found in environment"
  if [ -e "$SLACK_CONFIG" ]; then
    ((verbose)) && echo "Sourcing slack config file found in environment at $SLACK_CONFIG_FILE"
    source "$SLACK_CONFIG_FILE"
  elif [ -e "$HOME/.config/slack_export" ]; then
    ((verbose)) && echo "Sourcing slack config file in user home config folder $HOME/.config/slack_export"
    source "$HOME/.config/slack_export"
  elif [ -e "$DIR/.api-secrets" ]; then
    ((verbose)) && echo "Sourcing slack config file in repo folder $DIR/.api-secrets"
    source "$DIR/.api-secrets"
  fi
fi

if [ -z "$SLACK_KEY" ]; then
    echo "No Slack legacy api key found. Please place it in your SLACK_KEY environment variable or in $DIR/.api-secrets or in $HOME/.config/slack_export"
    die 1
else
  ((verbose)) && echo "Slack key found. Beginning export"
fi

# build a timestamp directory to store the data
month=`date +%m`
day=`date +%d`
year=`date +%y`
dumphere="${year}/${month}/${day}"
mkdir -p $dumphere

# dump each channel you want to archive here
for channel in ${CHANNELS}; do
    echo "Exporting history for \"$channel\" channel..."
    slack-history-export -t "$SLACK_KEY" -c $channel -F json -f $dumphere/$channel.json
done

# commit and push the export to version control
git add $dumphere/*
git commit -m "Adding Slack history for $dumphere" .
git push origin master
