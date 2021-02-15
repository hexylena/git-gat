from galaxy.jobs import JobDestination
from galaxy.jobs.mapper import JobMappingException
import os

def admin_only(app, user_email):
    # Only allow the tool to be executed if the user is an admin
    admin_users = app.config.get( "admin_users", "" ).split( "," )
    if user_email not in admin_users:
        raise JobMappingException("Unauthorized.")
    return JobDestination(runner="slurm")
