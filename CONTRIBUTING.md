# Contributing To ATS001

ATS001 covers Application Deployment in the Certified Kubernetes Application
Developer (CKAD) curriculum. Contributions can improve explanations, correct
resource relationships or review the original YAML knowledge checks.

## Before Editing

Read CLAUDE.md for shared writing rules and the repository's reading-only scope.
CURRICULUM.md maps the official objectives, and AUTHORING.yaml records module
goals and adaptation sources. Discuss substantial scope changes in a repository
issue so the teaching remains coherent.

The current manifest uses new reading modules. Earlier teaching, examples and
lab assets remain unchanged at their original paths outside this manifest.
LEGACY-CONTENT.json records their hashes. Preserve those assets unless a future
migration explicitly includes them. Do not add new labs or playgrounds to this
reading draft.

## Reading Structure

Each section starts with an introduction. A module contains a short course.md
landing page, developed course-0N-*.md lessons and a final course-0N-summary.md.
Register the introduction, landing, lessons and summary in that order in
astrona.yaml. The summary comes before the next module.

Technical Markdown retains draft front matter until review. Keep explanations
self-contained and use real technical terms in plain English. Define terms and
acronyms, explain responsible components and relevant limits, and end teaching
lessons with the Common pitfalls warning. Avoid invented outputs or claims that
an environment was executed. Author references belong in SOURCES.md.

## Reusable Questions

Write original questions under the versioned contract documented in ASSESSMENTS.md
and schemas/question-bank.schema.json. Each bank contains 5–15 questions with
stable IDs, one supported correct answer, per-option feedback, measurable goals
and source readings. assessments/index.yaml records checkpoint order and summary
anchors. Keep YAML data separate from the Markdown reading manifest.

## Review And Submission

Check reading paths, ordering, coverage, draft flags and question contracts.
Confirm that every question follows its teaching and that retained earlier files
still match their recorded hashes. Diagrams need structural and visual review;
do not claim rendering or runtime checks that were not performed.

Sign off commits under the [Developer Certificate of Origin](https://developercertificate.org/)
and open a focused pull request explaining the change and verification. Keep
publication draft until maintainers approve it.

This project follows the [Contributor Covenant](https://www.contributor-covenant.org/version/2/1/code_of_conduct/).
Contributions use the repository's Apache License 2.0; see LICENSE.
