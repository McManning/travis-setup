
# Travis Setup

Automatically adds a Travis CI configuration for deploying applications via ssh/rsync to remote hosts.

# Usage

## Create certificates

Certificate creation is a manual process in case you want to reuse certs across applications or have some other deployment process.

```sh
ssh-keygen -t rsa -b 4096 -C "travis-ci@example.com" -N '' -f /path/to/id_rsa
```

## Run setup image

Mount your checked out repository and private key and run the image directly:

```sh
docker run \
    -v /path/to/myrepo:/repo \
    -v /path/to/id_rsa:/id_rsa \
    mcmanning/travis-setup
```

Once you authenticate with Travis, your key will be securely pushed to Travis and a  `.travis` directory will be added to your project containing the deployment script.

## Configure `.travis.yml`

Update (or create) the `.travis.yml` to include required environment variables and deployment rules.

```yaml
...
env:
  global:
    - DEPLOY_HOST=example.com
deploy:
  provider: script
  script: bash .travis/deploy.sh
  skip_cleanup: true
  on:
    branch: master
```

### Available Environment Variables

|Variable|Default|Description|
|---            |---                            |---|
| DEPLOY_HOST   | required                      | SSH/rsync target host |
| DEPLOY_PORT   | default: `22`                 | SSH port for the target host |
| DEPLOY_USER   | default: `travis-ci`          | SSH user for the target host |
| DEPLOY_PATH   | default: `.`                  | Source path of the project to deploy from. For example, a React application would set this to `build` to deploy only the production bundle. |
| DEPLOY_ROOT   | default: `/home/$DEPLOY_USER` | Directory to rsync into on the target host |

# Deployment Targets

I run a containerized sshd specifically to handle rsync from Travis CI. YMMV

Simple example:
```sh
docker run -d \
    -p 2222:22 \
    -v /srv/travis-ci/id_rsa.pub:/etc/authorized_keys/travis-ci \
    -e SSH_USERS="travis-ci:1000:1000" \
    panubo/sshd
```

# TODO

* Automate creation (or update) of `.travis.yml`
* ... actually have the image create `.travis/deploy.sh`
* Rename environment variables. PATH/ROOT are too vague
* Post-rsync (or deployment) script execution (service restarts and whatnot)
