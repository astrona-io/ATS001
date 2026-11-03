---
draft: true
exam_objectives:
- Use the Helm package manager to deploy existing packages
---
# Finding, Packaging And Installing Charts

A colleague says to install the chart from the team repository at version 1.2.0 with three replicas. To do that you must add the repository, find the chart, read its default values and install a fixed version. The same skills let you install a chart from a downloaded archive when no repository is available.

## Learning Goals

- Add, update, search and remove a chart repository.
- Read a chart's values and metadata before installing it.
- Package a chart into an archive and install from the archive.
- Explain chart versions, the repository index and chart dependencies.

## Before You Start

You need the Helm command-line tool and a basic idea of what a chart and a release are. Use the module playground for the guided practice. It provides an isolated kind cluster with the `starfleet` namespace.

## Reading Order

1. Chart Repositories And Versions
2. Archives, Dependencies And Pulling Charts
3. Serve A Local Repository And Install From It
4. Summary

<!-- astrona:playground -->
