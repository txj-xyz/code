# `helm-chart`
This is a template repo for a HELM chart package.

This will run a `CronJob` on every node in the cluster running `linux`


# Building Chart Package `tgz`

```bash
# Build the repo using HELM packaging.
$ helm package .

# Add the new repo to your cluster repos.
$ helm repo add my-custom-repo https://github.com/user/cronjob-all-nodes

# Install the new chart
$ helm install my-job-name my-custom-repo/cronjob-all-nodes
```