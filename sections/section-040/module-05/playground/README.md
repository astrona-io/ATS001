# Find, Package And Install Charts Playground

Ungraded module environment: ats-001-playground-040-05. Kubernetes v1.35.0 is pinned by node image digest. Bootstrap only writes to the expected isolated context. No validation or grading block is registered in config.yaml.

```sh
astrona validate -c .
astrona run -c .
astrona destroy ats-001-playground-040-05
```

The author smoke script replays the practical reading from a temporary directory, including a local chart repository served on port 8879. It must run only after the playground starts, with its private kubeconfig, and needs Helm and Python 3. It has not been run: all of this material is untested until an author executes it on a working container engine.

```sh
KUBECONFIG="$(astrona kubeconfig ats-001-playground-040-05)" bash testing/smoke.sh
```
