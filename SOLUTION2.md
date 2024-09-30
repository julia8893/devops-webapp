# Deploy a containerized web application on your local Kubernetes cluster

## Step 1: Setup Rancher with Kubernetes Cluster

### Step 1.1: Install Rancher Desktop

kubectl on Windows: https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/
Rancher: https://rancherdesktop.io/

Check in Rancher Desktop if there are any problems -> Diagnostics
Factory Reset and Reset Kubernetes -> Troubleshooting

### Step 1.2: Verify the Kubernetes cluster is running

```
kubectl get nodes
```

## Step 2: Push Docker Image to a Registry

### Step 2.1: Build the Docker Image for the Next.js app

```
docker build -t my-dockerhub-username/nextjs-app:1.0 .
```

### Step 2.1: Build the Docker Image for the Next.js app

```
docker push my-dockerhub-username/nextjs-app:1.0
```

## Step 3: Deploy Next.js App on Kubernetes Using Rancher

### Step 3.1: Apply Deployment and Service YAML

Create files nextjs-deployment.yaml and nextjs-service.yaml

### Step 3.2: Apply the YAML Files

```
kubectl apply -f nextjs-deployment.yaml
kubectl apply -f nextjs-service.yaml
```

### Step 3.3: Monitor the Deployment

```
kubectl get deployments
kubectl get pods
```

### Step 3.4: Port-Forwarding

```
kubectl port-forward service/nextjs-service 8080:80
```

## Uninstall Kubernetes Resources (Additional)

```
kubectl delete --all pods --all-namespaces
kubectl delete --all deployments --all-namespaces
```

# Implement a rolling update strategy for zero-downtime deployments

## Step 1: Rolling Update

### Step 1.1: Rolling Update

```
kubectl set image deployment/nextjs-app nextjs-app=my-dockerhub-username/nextjs-app:2.0
```

### Step 1.2: Verifing the rolling update

```
kubectl rollout status deployment/nextjs-app
```

## Step 2: Scaling

### Step 2a.1: Scale by replicas

```
kubectl scale deployment nextjs-app --replicas=5
```

### Step 2b.1: Horizontal Pod Autoscaler (Optional)

https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/

#### Create HPA configuration

Create config-file nextjs-hpa.yaml

#### Apply the HPA configuration

```
kubectl apply -f nextjs-hpa.yaml
```

#### Check status of HPA

```
kubectl get hpa
```

#### Scale down, watch HPA and simulate a load test

```
kubectl scale deployment nextjs-app --replicas=1
```

```
kubectl get hpa nextjs-app-hpa --watch
```

```
kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://nextjs-service; done"
```

# Scale the application by adjusting replica counts using Kubernetes commands

## Scaling with kubectl CLI

### Replicas (CLI)

#### Check Current Replica Count

```
kubectl get deployment nextjs-app
```

#### Scale the Deployment

```
kubectl scale deployment nextjs-app --replicas=10
```

#### Verify the Scaling Operation

```
kubectl get deployment nextjs-app
```

### Autoscaler (CLI)

```
kubectl autoscale deployment my-web-app --min=3 --max=10 --cpu-percent=80
```

# Conclusion

Having replicas in a Kubernetes deployment is crucial for ensuring high availability and fault tolerance. By running multiple instances (replicas) of an application, if one pod fails or becomes unavailable, the remaining replicas can handle traffic, ensuring that the service remains operational without downtime. Replicas also enable load balancing, distributing incoming traffic across multiple pods for improved performance.

Using a Horizontal Pod Autoscaler (HPA) is beneficial because it automatically adjusts the number of replicas based on metrics like CPU or memory usage. This helps optimize resource usage by scaling up during high demand to handle traffic spikes, and scaling down during low demand to save on resources, thus ensuring both cost-efficiency and consistent performance.

A liveness probe checks whether the application is still running. If the probe fails, Kubernetes assumes that the container is in a bad state and will restart it to recover. In the provided deployment YAML, the liveness probe is configured to check the root path (/) of the Next.js app every 5 seconds, starting 10 seconds after the container starts. If the app becomes unresponsive or stuck, Kubernetes will restart the pod, helping it recover from failure.

A readiness probe determines if the application is ready to serve traffic. If this probe fails, Kubernetes will temporarily remove the pod from the service's load balancer until it passes again. This ensures that the pod is fully initialized and ready to handle requests, preventing traffic from being sent to an unready pod. In the YAML file, the readiness probe is also set to check the root path but waits only 5 seconds after the container starts, then checks every 10 seconds.
