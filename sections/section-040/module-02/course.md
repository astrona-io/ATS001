# Manage Releases From A Chart Repository

Astronaut, a busy planet collects ship kits over time: some old, some half-built, some waiting for a newer model. This module is about tidying that planet with Helm: removing an old release, upgrading another, installing a new one with your own options, and finding a kit stuck half-built on the launch pad.

Remember this sentence for the CKAD exam:

> Helm actions operate on releases; Kubernetes objects are the rendered result.

## Learning objectives

After this module you can:

- Explain what a release revision is, and which release states exist.
- List every release in a namespace, including ones stuck in `pending-install`, with `helm list --all`.
- Find which versions of a chart a repository has, and which values a chart supports.
- Uninstall, upgrade and install releases from a chart repository.

## Before you start

You need a Kubernetes cluster, `kubectl`, and the `helm` command (Helm 3). You should know what a chart, values and a release are.

This module is command-focused because the external chart repository is environment-specific. Its commands use a chart repository called `study-charts`, which your training cluster must provide. The address in the commands, `https://example.invalid/charts`, is a placeholder: replace it with the chart repository available in your training cluster. That is also why the pages show no command output.

## The parts of this module

Read the parts in this order. Each one takes about 5 to 10 minutes.

| Part | What you learn |
| --- | --- |
| [Releases And Their States](./course-01-releases-and-their-states.md) | Revisions, release states, adding a chart repository and reading a chart's values |
| [Tidy Up The Releases On A Planet](./course-02-tidy-up-the-releases-on-a-planet.md) | An exam-style task: uninstall, upgrade, install with values and remove a stuck release |
| [Wrap-Up: Mission Debrief](./course-03-wrap-up.md) | What you learned, exam habits, practice ideas and cleaning up |

## Why this matters

Exam tasks about Helm often mix several small jobs in one namespace. Each one is a single Helm command, but only if you work on the right release, with the right action, and with values the chart really supports. The habits here keep you from editing the Kubernetes objects by hand when the task is about releases.
