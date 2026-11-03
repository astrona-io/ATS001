# Canary Routing With Ingress Playground

Ungraded module environment: ats-001-playground-010-04. Kubernetes v1.35.0 is pinned by node image digest. Application tags identify versions but are not content-digest guarantees. Bootstrap only writes to the expected isolated context. No validation or grading block is registered in config.yaml.

```sh
astrona validate -c .
astrona run -c .
astrona destroy ats-001-playground-010-04
```

The environment guide in docs/overview.md describes the fixtures and access. Runtime evidence is pending: nobody has started this playground yet, and the static checks do not replace a live run.
