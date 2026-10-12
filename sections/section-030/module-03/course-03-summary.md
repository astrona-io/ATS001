---
draft: true
exam_objectives:
- Kustomize
---
# Summary

An overlay should express deliberate differences from shared resources. Patch matching, transformation behavior and schema semantics determine which objects and fields actually change.

Valid generated text can still lose a helper container or alter an unsuitable selector. Review effective object relationships, not only patch syntax, and keep immutable identity separate from intended routing and configuration differences.

A safe overlay expresses a deliberate environment difference and preserves unrelated application relationships. Patch target selection, merge behavior and immutable fields need separate review against the rendered object.

<!-- astrona:playground:destroy -->
