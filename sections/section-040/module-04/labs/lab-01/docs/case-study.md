---
draft: true
exam_objectives:
- Use the Helm package manager to deploy existing packages
---
# Starting Environment

The existing chart is supplied in full below. Save its three files in a local `chart` directory before inspecting or installing it. Release `demo` is already installed with one version-one replica.

Use the provided `probe-chart` chart, release `demo` in `starfleet`, and two replicas. Upgrade the seeded version-one release to `version: v2` while keeping the release name. The current release revision must be at least two. The client must reach the `helm-probe` Service. Do not replace Helm ownership with a manually applied Deployment.
