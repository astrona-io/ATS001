# Deployment Strategy, Scaling And Pause Environment

This ungraded playground provides an isolated kind cluster running Kubernetes v1.35.0. It uses its own kubeconfig. The namespace starfleet contains the probe Deployment, the probe Service and the shuttle client Pod. The outpost namespace contains the drifter client. The application reports its version, hostname and greeting on HTTP requests. No task is submitted for grading.

The relay Deployment has two replicas and an explicit RollingUpdate strategy with maxSurge 1 and maxUnavailable 1. The relay Service selects its Pods.

The probe container listens on port 8080 and the Service receives port 80. The application code is supplied through the probe-code ConfigMap. Its /ready and /health paths fail when /tmp/not-ready or /tmp/unhealthy respectively exists in the container. These marker files are controlled practice inputs rather than production health design.

Select the private kubeconfig before application commands:

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-playground-020-06)"
kubectl config current-context
kubectl -n starfleet get pods
```

The context must be kind-astro-ats-001-playground-020-06. If it differs, stop and select the module environment. Local node storage is temporary and does not survive playground destruction. Destroy and start the module again for a clean reset, or run:

```sh
astrona destroy ats-001-playground-020-06
```

The environment is ungraded, so submit is not part of its workflow.
