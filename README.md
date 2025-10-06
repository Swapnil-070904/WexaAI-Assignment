# DevOps Internship Assessment - Next.js Containerization & Kubernetes

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
cd "c:\Users\ak680\Desktop\wexa ai"
npm install
```

3. Run locally in development mode:

```bash
npm run dev
# open http://localhost:3000
```

Build and run Docker image locally

```bash
# build image (tag is local)
docker build -t nextjs-devops-assessment:local .
# run container
docker run -e PORT=3000 -p 3000:3000 nextjs-devops-assessment:local
# open http://localhost:3000
```

Push image to GitHub Container Registry (CI)

The included GitHub Actions workflow (`.github/workflows/ci.yml`) will build and push the image automatically on push to the `main` branch.

It tags images as:
- `ghcr.io/<OWNER>/nextjs-devops-assessment:${{ github.sha }}`
- `ghcr.io/<OWNER>/nextjs-devops-assessment:latest`

Notes:
- By default the workflow uses `GITHUB_TOKEN` to authenticate. If your org/policy requires a personal access token with `write:packages`, create a `CR_PAT` secret and replace `secrets.GITHUB_TOKEN` with `secrets.CR_PAT` in the workflow.

Deploy to Minikube

1. Start Minikube (if not running):

```bash
minikube start --driver=docker
```

2. (Optional) Load the image into Minikube if you built locally and didn't push to GHCR:

```bash
# if using local image
minikube image load nextjs-devops-assessment:local
```

3. Update the image in `k8s/deployment.yaml` to point to your GHCR image. Example:

```
image: ghcr.io/<YOUR_GITHUB_USERNAME>/nextjs-devops-assessment:latest
```

4. Apply manifests:

```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

5. Access the application:

```bash
# Using minikube service command (opens browser)
minikube service nextjs-service --url

# Or get node IP and nodePort
minikube ip
# then open http://<minikube-ip>:30080
```

Helpful commands

- Rollout status:

```bash
kubectl rollout status deployment/nextjs-deployment
```

- See pods and logs:

```bash
kubectl get pods
kubectl logs -l app=nextjs
```

Checklist for submission

- Create a public GitHub repo and push all files.
- Ensure the GHCR image built by Actions is visible (or push manually).
- Email the evaluator with subject: "DevOps Assessment Submission - [Your Name]" including:
  - Repository URL
  - GHCR image URL (e.g. `ghcr.io/<YOUR_USERNAME>/nextjs-devops-assessment:latest`)

Evaluation focus areas are Docker optimization, GitHub Actions correctness, Kubernetes configuration quality, and documentation clarity.

Good luck!
