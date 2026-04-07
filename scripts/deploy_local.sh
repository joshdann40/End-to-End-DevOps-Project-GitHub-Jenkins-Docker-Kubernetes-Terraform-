#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="devops-demo"
IMAGE="devops-demo:local"

docker build -t "$IMAGE" .
kind load docker-image "$IMAGE"
kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -
sed "s|__IMAGE__|$IMAGE|g" k8s/deployment.yaml | kubectl apply -n "$NAMESPACE" -f -
kubectl apply -n "$NAMESPACE" -f k8s/service.yaml

echo "Deployed. Run: kubectl get all -n $NAMESPACE"
