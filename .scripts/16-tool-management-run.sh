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
## Ensure the galaxy user is setup
sudo -u galaxy /srv/galaxy/venv/bin/python /usr/bin/galaxy-create-user -c /srv/galaxy/config/galaxy.yml --user admin@example.org --password password --key adminkey --username admin

# CMD
## Run command
wget {{ site.url }}{% link topics/sequence-analysis/tutorials/mapping/workflows/mapping.ga %}

# CMD
## Run command
workflow-to-tools -w mapping.ga -o workflow_tools.yml -l Mapping

# CMD
## Run command
shed-tools install -g https://$(hostname -f) -a adminkey --name bwa --owner devteam --section_label Mapping

# CMD
## Run command
shed-tools install -g https://$(hostname -f) -a adminkey -t workflow_tools.yml

# CMD
## Run command
shed-tools test -g https://$(hostname -f) -a adminkey --name bamtools_filter --owner devteam

# CMD
## Run command
get-tool-list -g "https://usegalaxy.eu" -o "eu_tool_list.yaml"
# Done!
git checkout main
