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

# Production
To deploy to production, utilise the terraform project in the `./terraform` directory


# Development

To deploy the project locally, you will need the following dependencies:
- Docker
- Docker Compose
- Minikube (running on Docker Engine)
- Terraform
- Helm (optional)
- Telepresence (optional)

This project only supports local development with minikube running on the docker engine.
Should you have a different container runtime, we aren't able to guarantee the following setups will work.

### 1. Start Minikube

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

### 2. Build all required images locally

In this step, we'll be using `docker compose` to build all the required images for our kubernetes deployment.

Head to the root directory of this project, and you will find a `docker-compose.yml` file which will be what we're using to build the images.

```bash
# build all the containers in the different sub projects
docker compose build
```

Take note that in order for minikube to use your images during the ArgoCD Apps Deployment, you will need to let minikube access your local docker registry with the following command:
```bash
eval $(minikube -p minikube docker-env)
```

### 3. Deploy ArgoCD locally

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

### 4. Deploy ArgoCD Apps

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

