# Install And Upgrade A Local Chart

Astronaut, the shipyard sells ship kits. Each kit comes with its parts and an order form, and you tick options on the form before it is built. Helm is that kit system for Kubernetes: a chart is the kit, values are the options you tick, and a release is one kit built and flying under its own name.

Remember this sentence for the CKAD exam:

> Helm values feed templates; upgrades create release revisions.

## Learning objectives

After this module you can:

- Explain what a chart, a template, values and a release are.
- Check a chart with `helm lint` and see what it would create with `helm template`.
- Install a release with values set on the command line, and upgrade it with new values.
- Read a release's history and its values with `helm history` and `helm get values`.
- Remove a release with `helm uninstall`.

## Before you start

You need a practice Kubernetes cluster, `kubectl` set up to talk to it, and the `helm` command (Helm 3) on your computer. You should know that a Deployment keeps a set number of pods running and that a Service sends traffic to them.

This module makes Helm executable without an external chart repository. You write a small local chart, `study-web`, in the first part, and install it into the namespace `helm-lab` in the second.

## The parts of this module

Read the parts in this order. Each one takes about 5 to 10 minutes.

| Part | What you learn |
| --- | --- |
| [What A Chart Is](./course-01-what-a-chart-is.md) | Chart files, templates and values; `helm lint` and `helm template` on a local chart |
| [Install, Upgrade And Uninstall](./course-02-install-upgrade-and-uninstall.md) | A release's whole life: install with values, upgrade, read the history, remove it |
| [Wrap-Up: Mission Debrief](./course-03-wrap-up.md) | What you learned, exam habits, practice ideas and cleaning up |

## Why this matters

The CKAD exam asks you to use Helm to deploy existing packages: install a chart with a value changed, upgrade a release, find what changed. Knowing which part of a chart a value feeds, and that every upgrade is a numbered revision, lets you do those tasks quickly and check them.
