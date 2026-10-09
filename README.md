# ATS001

[![Donate via Liberapay](https://liberapay.com/assets/widgets/donate.svg)](https://liberapay.com/Astrona.io/donate)

Free training material for the Certified Kubernetes Application Developer
(CKAD) exam: deployment strategies with plain Kubernetes objects (blue-green
and canary), rolling updates and rollbacks, Kustomize and Helm. Each module
is a short landing page, a few hands-on parts and a wrap-up. The course
outline the platform reads is `astrona.yaml`.

## Curriculum

| Section | Title | Exam topic | Graded lab |
| --- | --- | --- | --- |
| [010](sections/section-010/README.md) | Blue-Green Deployments | Deployment strategies (blue/green) | [Blue-Green Service Switch Lab](sections/section-010/module-01/labs/lab-01) |
| [020](sections/section-020/README.md) | Rolling Updates And Rollbacks | Deployments and rolling updates | None yet |
| [030](sections/section-030/README.md) | Canary Deployments With Kustomize | Deployment strategies (canary), Kustomize | None yet |
| [040](sections/section-040/README.md) | Deploy Packages With Helm | Helm | None yet |

## Running the lab

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS001.git -c sections/section-010/module-01/labs/lab-01
astrona submit -c sections/section-010/module-01/labs/lab-01
astrona destroy ast001-lab-010
```

The reading parts of sections 020 to 040 run on any practice cluster with
`kubectl` (for example one made with `kind create cluster`); section 040 also
needs `helm`.

## Support This Project

ATS001 is free CKAD training material. If it helped you, consider supporting
ongoing work via [Liberapay](https://liberapay.com/Astrona.io).
