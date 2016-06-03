# Recipe Box Infrastructure
This [TerraForm](http://terraform.io) repo is the infrastructure that supports the Recipe Box [App](https://github.com/arsdehnel/recipe-box) and [API](https://github.com/arsdehnel/recipe-box-api).

### Notes
- Make sure you `ssh-add` the appropriate instance public key to allow the bastion connection to work.

### Roadmap
###### Before production
- get ssh into app instance through bastion working in tf
- remove public ip from app instance
- get app to run the startup.sh boostrapping script through bastion

###### Long-term future
- autoscaling (future)
- multiple AZ