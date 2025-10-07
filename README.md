# WexaAI DevOps Assessment

This repository contains a minimal Next.js application and everything needed to containerize it, push the image to GitHub Container Registry (GHCR), and deploy to Kubernetes (Minikube).

Files and folders:
- `package.json` - project manifest
- `pages/index.js` - simple Next.js page
- `Dockerfile` - multi-stage Dockerfile optimized for builds
- `.dockerignore` - files excluded from build context
- `.github/workflows/ci.yml` - GitHub Actions workflow to build and push the image to GHCR
- `k8s/deployment.yaml` - Kubernetes Deployment manifest with health checks and replicas
- `k8s/service.yaml` - Kubernetes Service (NodePort) to expose the app in Minikube

Quick setup (local)

1. Install Node.js (v18+), npm, Docker, and Minikube.

2. Install project dependencies:

```bash
cd "WexaAi/"
npm install
```

3. Run locally in development mode:

```bash
npm run dev
# open http://localhost:3000
```

Build and run Docker image locally

```bash
# build image
docker build -t ghcr.io/<Username>/wexaai:latest .
# run container
docker run -p 3000:3000 ghcr.io/<Username>/wexaai:latest
# open http://localhost:3000
```

Push image to GitHub Container Registry

The included GitHub Actions workflow (`.github/workflows/ci.yml`) will build and push the image automatically on push to the `main` branch.

It tags images as:
- `ghcr.io/<Username>/wexaai:${{ github.sha }}`
- `ghcr.io/<Username>/wexaai:latest`


Deploy to Minikube
1. Start Minikube:

```bash
minikube start --driver=docker
```

2. Create a Kubernetes secret for GitHub Container Registry (GHCR) authentication:

```bash
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=<YOUR_GITHUB_USERNAME> \
  --docker-password=<YOUR_GITHUB_PERSONAL_ACCESS_TOKEN> \
  --docker-email=<YOUR_EMAIL>
```

3. Update the image in `k8s/deployment.yaml` to point to your GHCR image. Example:

```
image: ghcr.io/<YOUR_GITHUB_USERNAME>/wexaai:latest
```

4. Apply manifests:

```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

5. Access the application:

# get node IP and nodePort
```bash
minikube ip
# open http://minikube-ip:30000
```
