#!/bin/bash
set -ex

# Install dependencies before changing commits
find .scripts -name requirements.txt | xargs --no-run-if-empty -n 1 pip install -r
cat hosts | sed "s/^gat.*/$(hostname -f) ansible_connection=local ansible_user=$(whoami)/g" > ~/.hosts
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
git checkout $(git log main --pretty=oneline | grep "admin/ansible-galaxy/0006" | cut -c1-40)
## Run command
if [[ -z ${GALAXY_VERSION} ]]; then
ansible-playbook galaxy.yml -i ~/.hosts --vault-password-file ~/.vault-password.txt
else
ansible-playbook galaxy.yml -i ~/.hosts --vault-password-file ~/.vault-password.txt -e galaxy_commit_id=${GALAXY_VERSION}
fi

# CMD
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/ansible-galaxy/0011" | cut -c1-40)
## Run command
openssl rand -base64 24 > .vault-password.txt

# CMD
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/ansible-galaxy/0015" | cut -c1-40)
## Run command
if [[ -z ${GALAXY_VERSION} ]]; then
ansible-playbook galaxy.yml -i ~/.hosts --vault-password-file ~/.vault-password.txt
else
ansible-playbook galaxy.yml -i ~/.hosts --vault-password-file ~/.vault-password.txt -e galaxy_commit_id=${GALAXY_VERSION}
fi

# TEST
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/ansible-galaxy/0015" | cut -c1-40)
## Run test case
./.scripts/10-ansible-galaxy-test/0-galaxy-up.sh

# CMD
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/ansible-galaxy/0021" | cut -c1-40)
## Run command
if [[ -z ${GALAXY_VERSION} ]]; then
ansible-playbook galaxy.yml -i ~/.hosts --vault-password-file ~/.vault-password.txt
else
ansible-playbook galaxy.yml -i ~/.hosts --vault-password-file ~/.vault-password.txt -e galaxy_commit_id=${GALAXY_VERSION}
fi

# CMD
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/ansible-galaxy/0023" | cut -c1-40)
## Run command
if [[ -z ${GALAXY_VERSION} ]]; then
ansible-playbook galaxy.yml -i ~/.hosts --vault-password-file ~/.vault-password.txt
else
ansible-playbook galaxy.yml -i ~/.hosts --vault-password-file ~/.vault-password.txt -e galaxy_commit_id=${GALAXY_VERSION}
fi

# CMD
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/ansible-galaxy/0026" | cut -c1-40)
## Run command
if [[ -z ${GALAXY_VERSION} ]]; then
ansible-playbook galaxy.yml -i ~/.hosts --vault-password-file ~/.vault-password.txt
else
ansible-playbook galaxy.yml -i ~/.hosts --vault-password-file ~/.vault-password.txt -e galaxy_commit_id=${GALAXY_VERSION}
fi

# TEST
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/ansible-galaxy/0026" | cut -c1-40)
## Run test case
./.scripts/10-ansible-galaxy-test/1-galaxy-up.sh

# CMD
## Checkout
git checkout $(git log main --pretty=oneline | grep "admin/ansible-galaxy/0026" | cut -c1-40)
## Run command
if [[ -z ${GALAXY_VERSION} ]]; then
ansible-playbook galaxy.yml -i ~/.hosts --vault-password-file ~/.vault-password.txt
else
ansible-playbook galaxy.yml -i ~/.hosts --vault-password-file ~/.vault-password.txt -e galaxy_commit_id=${GALAXY_VERSION}
fi
# Done!
git checkout main
