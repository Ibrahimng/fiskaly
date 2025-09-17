`This README was generated and prepared with WARP AI-Assist`

# Kubernetes Deployment

This directory contains the Kubernetes deployment configuration using Helm charts for the Hello application.

## 📁 Structure

```
2-Kubernetes_Deployment/
├── hello/                  # Helm chart for the Hello application
│   ├── Chart.yaml         # Chart metadata and version info
│   ├── values.yaml        # Default configuration values
│   ├── .helmignore        # Files to ignore when packaging
│   ├── templates/         # Kubernetes YAML templates
│   │   ├── deployment.yaml    # Application deployment
│   │   ├── service.yaml       # Service definition
│   │   ├── ingress.yaml       # Ingress configuration
│   │   ├── serviceaccount.yaml # Service account
│   │   ├── hpa.yaml           # Horizontal Pod Autoscaler
│   │   ├── httproute.yaml     # Gateway API HTTPRoute
│   │   ├── _helpers.tpl       # Template helpers
│   │   ├── NOTES.txt          # Post-install notes
│   │   └── tests/            # Helm tests
│   └── charts/            # Chart dependencies (if any)
└── README.md              # This file
```

## 🚀 Quick Start

### Prerequisites

- Kubernetes cluster (local or remote)
- Helm 3.x installed
- kubectl configured to access your cluster

### Deploy the Application

#### Option 1: Using Helm directly
```bash
# Install the chart
helm install hello ./hello

# Upgrade the chart
helm upgrade hello ./hello

# Uninstall the chart
helm uninstall hello
```

#### Option 2: Using Skaffold (from parent directory)
```bash
cd ..
skaffold run --default-repo=your-dockerhub-username
```

## ⚙️ Configuration

### Key Configuration Values

Edit `hello/values.yaml` to customize your deployment:

```yaml
# Replica count
replicaCount: 1

# Image configuration
image:
  repository: hello-app
  tag: latest
  pullPolicy: IfNotPresent

# Service configuration
service:
  type: ClusterIP
  port: 80

# Ingress configuration
ingress:
  enabled: true
  hosts:
    - host: hello.fiscaly.local
      paths:
        - path: /
          pathType: ImplementationSpecific
```

### Override Values

You can override default values during installation:

```bash
# Override image tag
helm install hello ./hello --set image.tag=v2.0.0

# Override replica count
helm install hello ./hello --set replicaCount=3

# Use custom values file
helm install hello ./hello -f custom-values.yaml
```

## 🌐 Accessing the Application

After deployment, the application will be available at:

- **Local Development**: `http://hello.fiscaly.local/` (add to `/etc/hosts` if needed)
- **Ingress IP**: Check ingress address with `kubectl get ingress hello`

```bash
# Get ingress information
kubectl get ingress hello

# Get service information
kubectl get svc hello

# Get pod status
kubectl get pods -l app.kubernetes.io/name=hello
```

## 🔧 Troubleshooting

### Common Issues

1. **Image Pull Errors**
   ```bash
   # Check pod events
   kubectl describe pod <pod-name>
   
   # Verify image exists
   docker pull <image-name>
   ```

2. **Service Not Accessible**
   ```bash
   # Port forward to test locally
   kubectl port-forward svc/hello 8080:80
   # Access at http://localhost:8080
   ```

3. **Ingress Issues**
   ```bash
   # Check ingress controller logs
   kubectl logs -n kube-system -l app.kubernetes.io/name=traefik
   
   # Verify ingress configuration
   kubectl get ingress hello -o yaml
   ```

### Useful Commands

```bash
# View Helm releases
helm list

# Check chart status
helm status hello

# View rendered templates (dry run)
helm template hello ./hello

# Validate chart
helm lint ./hello

# Package chart
helm package ./hello
```

## 📊 Monitoring

The chart includes health checks and monitoring configurations:

- **Liveness Probe**: HTTP GET on `/` endpoint
- **Readiness Probe**: HTTP GET on `/` endpoint
- **Horizontal Pod Autoscaler**: Available but disabled by default

Enable HPA by setting:
```yaml
autoscaling:
  enabled: true
  minReplicas: 1
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80
```

## 🔐 Security

- Service account is created automatically
- Pod security context can be configured in `values.yaml`
- Security context for containers can be customized
- Image pull secrets supported if needed

## 📝 Notes

- The chart is compatible with Helm 3.x
- Default configuration uses Traefik ingress controller
- Gateway API HTTPRoute support is available but disabled by default
- Chart follows Helm best practices and includes comprehensive templates

## 🤝 Contributing

When making changes to the chart:

1. Update the `version` in `Chart.yaml`
2. Test with `helm lint ./hello`
3. Test deployment with `helm install --dry-run --debug`
4. Update this README if adding new features