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
astrona.yaml                                # Course outline: every reading page and lab, in order
CLAUDE.md                                   # Writing rules and repository facts (read this first)
sections/section-0N0/README.md              # Section overview (plus section.yaml)
sections/section-0N0/module-0M/course.md    # Module landing page
sections/section-0N0/module-0M/course-0N-*.md  # Module parts, ending with a wrap-up
sections/section-0N0/module-0M/examples/    # Reference copies of the files the pages ask you to save
sections/section-0N0/module-0M/labs/lab-0N/ # Graded lab: config.yaml, question.md, solution.md, manifests/, solution/, validation/
```

Every page and lab referenced in `astrona.yaml` must exist on disk at the `path`
given, and every course page on disk should be listed in `astrona.yaml` (never
`solution.md`). When adding, splitting or renaming a page or lab, update
`astrona.yaml` in the same change.

## Content Conventions

`CLAUDE.md` holds the full rules. In short:

1. Plain English at about a grade 8 to 9 reading level, short paragraphs, active voice.
2. A module is a short landing page, a few short parts (one idea each) and a wrap-up.
3. Every `##` heading that has `###` subsections starts with a short intro.
4. Explain each exam term the first time it appears, with the space analogy from the glossary in `CLAUDE.md`.
5. YAML goes to a file first: "Save this as ...", "Apply it:", "Then check the result:".
6. Each part ends with a `## Common pitfalls` warning box; a part that a graded lab tests ends with `## Your mission`.
7. Pages do not link to outside websites. Official documentation links go only in the `resources` field of a lab entry in `astrona.yaml`.
8. Never change commands, YAML or output to fit the style, and never make up output.

## Technical Guidelines

- Commands must be tested against a real cluster (Kind or equivalent) before submitting.
- Prefer `kubectl` imperative commands when they produce the correct object; use YAML
  when field placement is the point of the exercise.
- Always namespace commands explicitly (`-n <namespace>`) — don't rely on a default
  namespace.
- Link to official documentation only in a lab entry's `resources` in `astrona.yaml`.
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
