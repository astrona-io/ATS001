# Reusable Question Banks

Each section has one question bank, `sections/section-0N0/quiz.yaml`. The
final domain quiz is `sections/final-domain-quiz.yaml`. Every bank is
registered in `astrona.yaml` as a `type: quiz` entry with `pass_score: 70`.
The section quiz comes after the section capstone lab. The final quiz is the
last entry of the last module. There is no separate index file and no
`questions.yaml`: the manifest order is the teaching order.

Banks contain 5–15 original single-choice questions, scoped to concepts taught
in the course. They remain draft for review.

## Fields

- `id`: stable bank or question identity; preserve it when editing wording.
- `scope`: section or domain checkpoint.
- `learning_objective`: the measurable outcome checked by the question.
- `source_readings`: author traceability to the teaching; not learner navigation.
- `prompt`: learner-visible question text.
- `options`: stable option IDs, answer text and per-option feedback.
- `correct_option`: the ID of the single correct option.
- `explanation`: feedback reinforcing the supported answer.

The banks contain answer keys and are public learning material, so this is not
a secure examination bank. Do not treat scores as an official CKAD result.

## Graded Lab Expansion

Each active module has a draft independent graded lab, and each section has a
capstone lab. They are registered after the readings they practise. Each has
its own cluster, task, solution, context guards, reference repair and behavior
grader. Live verification is pending: nothing in this repository has been run
against a cluster.

| Section | Labs in teaching order |
| --- | --- |
| 010 | Switch A Service To A Ready Deployment; Configure Stable And Canary Backends; Create A Weighted Canary Ingress; Blue-Green And Canary Release Capstone |
| 020 | Perform A Rolling Template Update; Recover A Failed Deployment Update; Roll Back To A Named Revision; Switch To Recreate And Scale With One Rollout; Deployment Rollout Repair And Strategy Capstone |
| 030 | Apply A Kustomize Base; Patch A Preview With Kustomize; Generate A ConfigMap With Kustomize; Kustomize Section Capstone |
| 040 | Install A Chart With Explicit Values; Upgrade An Existing Helm Release; Package A Chart And Install It From The Archive; Helm Section Capstone |
