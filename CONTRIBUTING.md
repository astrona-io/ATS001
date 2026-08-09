# Contributing to ATS001

Thanks for considering a contribution. ATS001 is CKAD ("Application Design and Build")
training material, published in the open so anyone preparing for the exam — or
learning Kubernetes application patterns — can use, fix, and extend it. Contributions
of any size are welcome: typo fixes, clearer explanations, new labs, bug reports.

## Code of Conduct

This project follows the [Contributor Covenant](https://www.contributor-covenant.org/version/2/1/code_of_conduct/).
By participating, you agree to uphold it. Report violations to the maintainers
listed in the repository.

## Ways to Contribute

- **Report a problem** — broken command, wrong expected output, outdated API version,
  unclear explanation. Open an issue with the section/lab path and what you observed.
- **Improve existing content** — clarify wording, fix a manifest, correct a command,
  tighten a "Common Mistakes" or "Troubleshooting" section.
- **Add a lab or section** — new CKAD-relevant scenario not yet covered.
- **Review pull requests** — technical review from anyone is welcome, not just
  maintainers.

## Before You Start

For anything beyond a small fix (new lab, restructuring, new section), open an issue
first to discuss scope. This avoids duplicate work and keeps the training material
consistent. Small fixes (typos, broken links, command corrections) can go straight to
a pull request.

## Project Structure

```
astrona.yaml                # Training manifest: metadata, sections, labs
sections/<section-id>/      # section.yaml + README.md (concept material)
labs/<lab-id>/               # README.md + manifests/ (hands-on exercises)
```

Every section and lab referenced in `astrona.yaml` must exist on disk at the `path`
given, and every section/lab directory on disk should be registered in `astrona.yaml`.
When adding or renaming a section or lab, update `astrona.yaml` in the same change.

## Lab Content Conventions

Existing labs follow a consistent shape — match it so the training series stays
predictable for learners:

1. Title and one-line exam-relevant summary
2. A single bolded "remember this sentence" takeaway for the exam
3. **What You Learn**
4. **Objects In This Lab** (tables for objects/labels where useful)
5. **Study First** — questions to reason through before running commands, with
   expected reasoning given afterward
6. **Prerequisites**
7. Numbered **Step N** sections with runnable `kubectl` commands and expected output
8. **Command Summary**
9. **Troubleshooting**
10. **Common Mistakes**
11. **Practice Variations**
12. **Cleanup**
13. **CKAD Exam Notes**
14. **Related Commands**
15. **References** — link to official Kubernetes docs, not third-party blogs

Manifests live under `labs/<lab-id>/manifests/`, at minimum a `lab-start.yaml`, and a
`solution.yaml` where a full worked solution helps.

## Technical Guidelines

- Commands must be tested against a real cluster (Kind or equivalent) before submitting.
- Prefer `kubectl` imperative commands when they produce the correct object; use YAML
  when field placement is the point of the exercise.
- Always namespace commands explicitly (`-n <namespace>`) — don't rely on a default
  namespace.
- Link only to official Kubernetes documentation (kubernetes.io) in **References**.
- Keep exercises CKAD-scoped: Application Design and Build domain topics, not cluster
  administration.

## Submitting Changes

1. Fork the repository and create a branch from `main`.
2. Make your change, following the conventions above.
3. Test every command you add or modify against a real cluster.
4. Sign off your commits per the [Developer Certificate of Origin](https://developercertificate.org/)
   (`git commit -s`) — this certifies you have the right to submit the contribution
   under this project's license.
5. Open a pull request describing what changed and why, referencing any related issue.
6. Address review feedback. Maintainers may request changes to keep content accurate
   and consistent with the rest of the series.

## License

By contributing, you agree your contributions are licensed under the same license as
this project (Apache License 2.0, see `LICENSE`).
