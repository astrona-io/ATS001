---
draft: true
exam_objectives:
- Use the Helm package manager to deploy existing packages
---
# Summary

A chart repository is a web server with chart archives and an index file. Helm keeps a local copy of the index, and searching and installing use that copy, so a repository must be updated before new versions appear.

The chart version identifies a package and changes with every change to the chart. The application version is only information. Installing with an explicit version gives the same result each time, and installing without one takes the newest stable version.

Before an install, `helm show` prints the metadata, README and default values, and `helm lint` checks a chart directory. A chart can be installed from a repository, from an archive made with `helm package`, from a directory, or from an OCI registry. Dependencies are listed in `Chart.yaml`, downloaded into the `charts` directory by `helm dependency update` and installed in the same release as the parent.

<!-- astrona:playground:destroy -->
