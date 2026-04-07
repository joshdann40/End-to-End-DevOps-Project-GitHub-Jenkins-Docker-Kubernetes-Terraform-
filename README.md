# End-to-End DevOps Project (GitHub + Jenkins + Docker + Kubernetes + Terraform)

This repository provides a complete starter blueprint for an end-to-end DevOps workflow:

1. **Source code in GitHub** (Flask app + tests)
2. **CI/CD with Jenkins** (test, build image, push, deploy)
3. **Containerization with Docker**
4. **Deployment to Kubernetes**
5. **Infrastructure provisioning with Terraform**

## Project Structure

- `app/` - Flask app
- `tests/` - Pytest tests
- `Dockerfile` - Container image build
- `Jenkinsfile` - Jenkins pipeline
- `k8s/` - Kubernetes manifests
- `terraform/` - Terraform for EKS cluster resources
- `.github/workflows/validate.yml` - Optional GitHub validation workflow
- `scripts/deploy_local.sh` - Local deploy helper for `kind`

## Prerequisites

- GitHub repository
- Jenkins server with Docker + kubectl access
- DockerHub account (or other registry)
- Kubernetes cluster (EKS recommended in this template)
- Terraform >= 1.6
- AWS IAM roles for EKS cluster and node groups

## Step-by-Step Setup

### 1) Push source code to GitHub

```bash
git init
git remote add origin <your-github-repo-url>
git add .
git commit -m "Initial DevOps project"
git push -u origin main
```

### 2) Build and test locally

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r app/requirements.txt pytest
pytest
docker build -t devops-demo:local .
```

### 3) Provision Kubernetes infra with Terraform (AWS EKS)

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

> Update `terraform.tfvars` and provide IAM role ARNs securely (variables or CI secrets).

### 4) Configure Jenkins pipeline

Create a **Pipeline** job in Jenkins and point it to this repo.

Required Jenkins credentials:
- `dockerhub-creds` (username/password)

Required Jenkins environment variables:
- `DOCKERHUB_USERNAME`

Jenkins executes stages in `Jenkinsfile`:
- Checkout
- Pytest
- Docker build
- Docker push
- Kubernetes deploy (`kubectl apply`)

### 5) Deploy manifests manually (optional)

```bash
kubectl create namespace devops-demo --dry-run=client -o yaml | kubectl apply -f -
sed "s|__IMAGE__|<dockerhub-user>/devops-demo:<tag>|g" k8s/deployment.yaml | kubectl apply -n devops-demo -f -
kubectl apply -n devops-demo -f k8s/service.yaml
kubectl get svc -n devops-demo
```

## Local Kubernetes Quick Test (kind)

```bash
./scripts/deploy_local.sh
```

## Improvements you can add

- Helm charts instead of raw manifests
- Argo CD / GitOps deployment
- Security scans (Trivy, Snyk)
- Policy checks (OPA/Gatekeeper)
- Observability (Prometheus + Grafana + Loki)
