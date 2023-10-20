# Cob
Cob is a challenge coding challenge platform for the likes of System Administators

# Quick Start
To start, simply clone this project along with its submodules with:
```bash
git clone --recurse-submodules git@gitlab.com:cs302-2023/g3-team8/project/cob.git 
```

Alternatively, if you've already clone it without the `--recurse-submodules` flag, you can use the following commands to init them seperately:
```bash
git submodule init
git submodule update
```

# Development

To deploy locally for development, you will need the following dependencies:
- Tilt
- Docker
- Minikube (on Docker Engine)

This project only supports local development with minikube running on the docker engine.
Should you have a different container runtime, we aren't able to guarantee the following setups will work.

### Start Minikube

Make sure your Minikube is started, you can run the following commands to check if your minikube is running
```bash
# run this command and you should see the following output if you cluster is already started
minikube status
# output:
# minikube
# type: Control Plane
# host: Running
# kubelet: Running
# apiserver: Running
# kubeconfig: Configured

# should your minikube cluster not be started yet, you can use the following command to start it:
minikube start
```

### Developing
To start the project with Tilt, enter the root directory of this project and run the following command
```bash
# to start development servers
tilt up
```

After running the commands, images will then be built locally and deployed with helm charts. Tilt will then listen for any changes in the relevant project paths and rebuild them if necessary.

Head to (http://localhost:10350/)[http://localhost:10350/] to see your project's overview and logs. Alternatively, you may also view the logs with the terminal you ran the previous command in by pressing the `s` key.

To stop the project, simply run the following command:
```bash
# stop the development servers
tilt down
```


# Production

To deploy to production, you will need the following dependencies:
- Google Cloud Account
- Kubectl
- Terraform
- Helm (optional)
- Telepresence (optional)

To deploy to production, utilise the terraform project in the `./terraform` directory

### Deploy ArgoCD

You will then need to deploy ArgoCD locally with the terraform sub-project located at `./terraform/2.argocd/`

```bash
# terraform/2.argocd
terraform apply --auto-approve
```

After deploying ArgoCD onto minikube, you will need to forward ArgoCD's server port in order for the next steps to run.

You can forward ports by running the following commands:

```bash
# forward argocd server's port 443 to your localhost port 8080
kubectl port-forward service/argocd-server -n argocd 8080:443
```

By default, ArgoCD will also generate a default admin password for the `admin` user. Take note that you will need this password in the next step.

To obtain this password, you can run the following command:
```bash
# gets the inital password set - you will need this password in the next step
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Deploy ArgoCD Apps

To deploy the ArgoCD Apps (all the services), you will need to use the terraform sub-project located at `./terraform/3.argoapps/`:

Before you can proceed, you will to place the following files in the `./terraform/3.argoapps/` directory:
> `.env` - Contains all the Environment Variables to pass to all the services

> `challenge-bucket-key.json` - The service account/key to access the GCS Bucket

> `argocd.key` - The deployment key (private key) added to gitlab


After you have placed the required files above, you can then run the following command todeploy the services:
```bash
# deploy locally
terraform apply --auto-approve
```

