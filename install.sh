#!/bin/bash

echo -ne '\n\n\n cloning github repos \n\n\n\n'
git clone https://github.com/devcontainers/features.git


echo -ne '\n\n\n installing neccasary apps, press y if it asks\n\n\n\n'
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install cron
sudo apt-get install -y tigervnc-standalone-server novnc websockify
sudo apt-get install -y xfce4 xfce4-terminal

echo -ne '\n\n\n setting up cron\n\n\n\n'
sudo service enable cron
sudo service status cron

echo -ne '\n\n\n moving and settup the startup script\n\n\n\n'
chmod +x ./startup.sh

mv ./startup.sh /workspaces/

# Absolute path to the script/command you want to run at startup
TARGET="/workspaces/startup.sh"

# Cron job definition
CRON_JOB="@reboot $TARGET >> /var/log/startup_script.log 2>&1"

# Check if the cron job already exists
( crontab -l 2>/dev/null | grep -F "$CRON_JOB" ) && {
    echo "Cron job already exists."
    exit 0
}

# Add the cron job
( crontab -l 2>/dev/null; echo "$CRON_JOB" ) | crontab -
echo "Cron job added: $CRON_JOB"

echo -ne '\n\n\n installing firefox \n\n\n\n'

sudo install -d -m 0755 /etc/apt/keyrings

wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nThe key fingerprint matches ("$0").\n"; else print "\nVerification failed: the fingerprint ("$0") does not match the expected one.\n"}'

echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null

echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla

sudo apt-get install firefox-esr

echo -ne '\n\n\n\n\n\n\n'
echo instalation is complete
echo "pls run this command /workspaces/startup.sh for firstime"
echo "then go to the ports tab and click on the globe icon next to the 6080 port"
echo if no ports show up try running the command as said earlier
