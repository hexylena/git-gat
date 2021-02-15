from galaxy.jobs import JobDestination
from galaxy.jobs.mapper import JobMappingException
import os

def sorting_hat(app, user):
    # Check that the user is not anonymous
    if not user:
        return app.job_config.get_destination('slurm')

    # Collect the user's roles
    user_roles = [role.name for role in user.all_roles() if not role.deleted]

    # If any of these are prefixed with 'training-'
    if any([role.startswith('training-') for role in user_roles]):
        # Then they are a training user, we will send their jobs to pulsar,
        # Or give them extra resources
        return app.job_config.get_destination('slurm-2c') # or pulsar, if available

    return app.job_config.get_destination('slurm')
