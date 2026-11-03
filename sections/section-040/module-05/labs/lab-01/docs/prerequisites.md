---
draft: true
exam_objectives:
- Use the Helm package manager to deploy existing packages
---
# Prerequisites

Use a host shell with astrona, kubectl and Python 3. This task also needs Helm, the Kubernetes package manager, version 3 or later, installed on the host and on your `PATH`. Check it before you start:

```sh
helm version --short
```

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-lab-040-05-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-lab-040-05-01" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.
