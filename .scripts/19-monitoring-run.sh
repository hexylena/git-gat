#!/bin/bash
set -ex

# Install dependencies before changing commits
find .scripts -name requirements.txt | xargs --no-run-if-empty -n 1 pip install -r
echo '[galaxyservers]' > ~/.hosts
echo "$(hostname -f) ansible_connection=local ansible_user=$(whoami)"  >> ~/.hosts
echo '[pulsarservers]' >> ~/.hosts
echo "$(hostname -f) ansible_connection=local ansible_user=$(whoami)"  >> ~/.hosts
export GALAXY_HOSTNAME="$(hostname -f)"
export GALAXY_API_KEY=adminkey
## The students should use a random password, we override with 'password' for reproducibility
echo 'password' > ~/.vault-password.txt;
## And one in this directory, it can contain garbage
echo 'garbage' > ./.vault-password.txt;
## Ensure the galaxy user is setup
sudo -u galaxy /srv/galaxy/venv/bin/python /usr/bin/galaxy-create-user -c /srv/galaxy/config/galaxy.yml --user admin@example.org --password password --key adminkey --username admin

# CMD
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/monitoring/0000" | cut -c1-40)
## Run command
ansible-galaxy install -p roles -r requirements.yml

# CMD
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/monitoring/0003" | cut -c1-40)
## Run command
ansible-playbook galaxy.yml -i ~/.hosts --vault-password-file ~/.vault-password.txt

# CMD
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/monitoring/0005" | cut -c1-40)
## Run command
ansible-galaxy install -p roles -r requirements.yml

# CMD
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/monitoring/0008" | cut -c1-40)
## Run command
ansible-playbook monitoring.yml -i ~/.hosts --vault-password-file ~/.vault-password.txt

# CMD
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/monitoring/0010" | cut -c1-40)
## Run command
ansible-playbook galaxy.yml -i ~/.hosts --vault-password-file ~/.vault-password.txt

# CMD
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/monitoring/0012" | cut -c1-40)
## Run command
ansible-galaxy install -p roles -r requirements.yml
# Done!
git checkout main
