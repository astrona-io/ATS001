---
draft: true
exam_objectives:
- Kustomize
---
# Starting Environment

The application and client fixtures are healthy. Complete the required change without replacing unrelated resources.

Keep a two-replica version-one base. Create a preview overlay that patches `probe` to one replica, template label `environment: preview` and `VERSION=preview`. Apply the overlay without editing the base. The client must receive the preview version. Grading checks the deployed preview; the file layout is checked by the author render test.
