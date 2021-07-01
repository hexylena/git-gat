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

# CMD
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/ansible-galaxy/0000" | cut -c1-40)
## Run command
ansible-galaxy install -p roles -r requirements.yml

# CMD
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/ansible-galaxy/0005" | cut -c1-40)
## Run command
ansible-playbook galaxy.yml -i ~/.hosts --vault-password-file ~/.vault-password.txt

# CMD
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/ansible-galaxy/0010" | cut -c1-40)
## Run command
openssl rand -base64 24 > .vault-password.txt

# CMD
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/ansible-galaxy/0014" | cut -c1-40)
## Run command
ansible-playbook galaxy.yml -i ~/.hosts --vault-password-file ~/.vault-password.txt

# CMD
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/ansible-galaxy/0016" | cut -c1-40)
## Run command
ansible-playbook galaxy.yml -i ~/.hosts --vault-password-file ~/.vault-password.txt

# TEST
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/ansible-galaxy/0016" | cut -c1-40)
## Run test case
./.scripts/10-ansible-galaxy-test/0-galaxy-up.sh

# CMD
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/ansible-galaxy/0022" | cut -c1-40)
## Run command
ansible-playbook galaxy.yml -i ~/.hosts --vault-password-file ~/.vault-password.txt

# CMD
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/ansible-galaxy/0022" | cut -c1-40)
## Run command
mkdir -p templates/galaxy/config/

# CMD
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/ansible-galaxy/0027" | cut -c1-40)
## Run command
ansible-playbook galaxy.yml -i ~/.hosts --vault-password-file ~/.vault-password.txt

# CMD
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/ansible-galaxy/0030" | cut -c1-40)
## Run command
ansible-playbook galaxy.yml -i ~/.hosts --vault-password-file ~/.vault-password.txt

# TEST
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/ansible-galaxy/0030" | cut -c1-40)
## Run test case
./.scripts/10-ansible-galaxy-test/1-galaxy-up.sh

# CMD
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/ansible-galaxy/0030" | cut -c1-40)
## Run command
ansible-playbook galaxy.yml -i ~/.hosts --vault-password-file ~/.vault-password.txt
# Done!
git checkout main
