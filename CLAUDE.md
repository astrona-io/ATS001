# Writing style for this repo

All study text here (course pages, lab docs, READMEs, comments in YAML and
scripts) is for people learning a technical subject, often for a
certification exam. Many of them are not native English speakers and have no
university degree.

## Plain English

Write the text in Plain English for a general adult audience (18+) without a
university degree. The content must be highly accessible and easy to
understand for non-technical readers, without feeling childish.

Strict guidelines:

1. Target a Flesch-Kincaid Grade Level of 8 or 9 (equivalent to a standard
   newspaper article).
2. Avoid all technical jargon, acronyms, and corporate buzzwords. If a
   technical term is necessary, explain it immediately using an everyday
   analogy.
3. Keep sentences conversational and direct. Split long sentences into two.
4. Use short paragraphs (max 3-4 sentences per paragraph) and clear
   subheadings to make the text scannable.
5. Use the active voice (e.g., "We did this" instead of "This was done by us").

## How this applies to course material

- **Know which file you are in.** A module has a short landing page and a few
  deep-dive parts. The landing page is a map: goals, what to know first, the
  order of the parts, where it fits. The real teaching goes in the parts. A lab
  has a task, a step-by-step solution and a short intro. Keep each file to its
  job. Do not add "Prerequisite: ... Next: ..." navigation lines to pages;
  the landing page and the course outline already give the order.
- **Keep each part short.** One idea per part, about 5 to 8 minutes of
  reading and at most about 8 command blocks, so a learner can finish it with
  the playground in one sitting of about 15 minutes. Split at a natural seam
  where each half ends with something the learner has seen work. Never split
  only to hit a number. When you split, renumber the files, fix every "Part N"
  reference in the module, the wrap-up links and `astrona.yaml`.
- **Every heading gets an intro.** A `##` section that has `###`
  subsections starts with one to three sentences that say what the section
  is about and why it matters, before the first `###`. Never put a `###`
  directly under a `##`.
- **Every module stands on its own.** Never refer to other sections or
  modules: no "see section 040", "as module 3 showed", "you met this in
  section 000", and no links to pages in another module. If the reader needs
  a fact from elsewhere, state the fact directly in one or two sentences.
  This also goes for parts of the same module: never write "Part 2 shows",
  "from Part 1" or "as in Part 3". Say the fact itself ("the commands below
  need the `web-svc` Service from the starting state"). The wrap-up page is the one
  exception: it recaps each part and links to it.
  The landing page does not have a "Where this fits" section.
- **Write words out in full.** Do not use informal short forms in prose:
  write "communications", "configuration", "repository", "administrator",
  "for example" and "that is", never "comms", "config", "repo", "admin",
  "e.g." or "i.e.". Names in code, commands and file paths stay as they are.
- **Exam terms stay.** The product's own names are what the reader must learn
  (for example a resource kind, a field, a command). Keep them, but explain
  each one in plain words, with an everyday analogy, the first time it appears
  in a file. Spell out acronyms on first use, with a short plain meaning.
- **Analogies come from space, and the reader is an astronaut.** When a term
  needs an everyday picture, use space: spaceships, planets, solar systems,
  space stations, mission control, signals, docking, star charts, airlocks,
  even the Death Star. Talk to the reader as an astronaut (for example "your
  first mission", "astronaut, check your flight log"), but not in every
  sentence. Requests are **signals** that ships send to each other. Use one
  analogy per hard idea, keep it short, and keep it the same everywhere (if
  the repository has an analogy glossary, use it). The analogy helps the reader; it
  never replaces the real term, and it never changes code or output.
- **Show one real example before the rule.** Start with a concrete case the
  reader can run, then give the general rule.
- **Say which part does the work.** Readers often mix up the parts of a system
  that sit close together. Whenever something happens, say which component
  did it.
- **Never change code to fit the style.** Commands, configuration files, field
  names, resource names, log lines and command output stay exactly as they
  are. They were run and checked on a real system. Never make up command
  output. If you shorten it, say that you did.
- **Prose only.** The grade-level and sentence rules apply to explanations.
  They do not apply to code blocks, tables of field names or reference lists
  (those may stay short and dense).
- **Keep the page furniture the same.** Hands-on steps are normal page
  content, not boxes: a short `###` subsection (for example "See it in your
  playground") with one sentence saying what to do, the command, the real
  output, and one or two sentences saying what it shows. A `> [!TIP]` box is
  only for a real tip: advice the reader can reuse beyond this one step (a
  habit, a shortcut, how to spot a problem, an exam habit). Everything else
  is a normal sentence: notes about the current step ("if the log line is
  old, run it again"), background facts, optional extra steps, and plain
  information. Never a command snippet, never two in a row, and most pages
  need zero or one tip. Each part ends with a
  `## Common pitfalls` `> [!WARNING]` block for that part only. Use a Mermaid
  diagram for a flow, an order or a state change, keep it under about 12
  boxes, and follow it with one sentence that says what it shows.
- **Labs come right after the part they practise.** Do not collect all
  graded labs at the end of a module. In `astrona.yaml`, put each lab (its
  `question.md` reading and the `lab` entry) right after the reading part it
  tests. If a part teaches a gradeable skill and no lab covers it, create a
  new lab. That part then ends with a `## Your mission: <lab title>` section:
  one sentence on what the reader can now do, one on what the mission asks,
  then pause the playground (`astrona stop <playground name>`), the
  `astrona run` and `astrona submit` commands, and finally
  `astrona destroy <lab name>` plus `astrona start <playground name>`. The
  wrap-up lists the missions and ends with cleaning up the playground
  (`astrona list`, `astrona destroy <playground name>`).
- **Renew the playground before hands-on work.** Every reading part that
  runs commands has `<!-- astrona:playground:renew -->` exactly once, on its
  own line, right before the first hands-on step (the first "Save this as"
  or the first command block), so the playground timer is reset before the
  learner needs the playground. Not on landing pages (they carry
  `<!-- astrona:playground -->`), wrap-up pages or pages without commands.
- **Mermaid without HTML.** The platform renders Mermaid with HTML labels
  switched off, so `<br/>` and any other HTML tag break the drawing. Rules:
  - One line per box, no `<br/>`, no HTML. Keep the box to the thing's name
    (`"web-blue"`, `"ReplicaSet"`, `"Service: web-svc"`).
  - Put the logic on the arrows: `S -->|"version: blue"| B`,
    `D -->|"creates"| R`, `H -->|"replicaCount: 3"| U`. Keep edge labels short.
  - Quote every label. Prefer `flowchart TB`; use `LR` only for a short chain.
  - Sequence diagrams: short participant aliases (`participant K as kubectl`)
    and short message text.
  - Anything longer (cluster names, full hostnames) goes in the sentence under
    the diagram.
- **No links to outside sources.** Course pages, labs and playground docs do
  not link to or point at outside websites (the one exception is the
  `resources` field of a lab entry in `astrona.yaml`) (official docs, GitHub, blogs,
  RFCs), and they have no "Reference" or "Official docs" lists. Everything the
  reader needs is explained on the page itself. Not affected: addresses the
  reader actually uses in a command or browser (`http://127.0.0.1:9080`,
  `curl https://httpbin.org`), and the Mission Briefing's contributors and
  "report a mistake" links.
- **Configuration goes to a file first.** Whenever the reader should apply
  YAML (course parts, playground docs, labs), use three separate steps:
  1. "Save this as `deployment-cassini.yaml`:" followed by a plain
     ` ```yaml ` block with only the YAML. No `cat > file <<'EOF'`, no
     `kubectl apply -f - <<EOF`, no shell around it.
  2. "Apply it:" followed by a ` ```sh ` block with only
     `kubectl apply -f deployment-cassini.yaml`.
  3. "Then check the result:" followed by the check commands, if any.
  The file name says the kind and the object. If a value must come from the
  reader's cluster (an IP address), use a placeholder like `<PARTNER>` in the
  YAML and say how to get the value (`echo $PARTNER`); never put shell
  variables inside YAML. Apply an object the first time its YAML appears; do
  not show it once "to read" and paste it again later. Never tell the reader
  to apply something from the playground's `examples/` folder: they start the
  playground with `astrona run`, so that folder is not on their machine.
- **Helpers have readable names.** Shell helper functions and variables use
  names that say what they do (`check_route`, `count_versions`,
  `$SERVICE_URL`), never single letters.

## About this repo (ATS001 only)

Everything above is general and can be copied to other course repositories. This
section is only true for this one.

### What the student is trying to learn

- **The goal:** pass the application deployment part of the **Certified
  Kubernetes Application Developer (CKAD)** exam from the Cloud Native
  Computing Foundation (CNCF). `astrona.yaml` and the `README.md` name the
  domain **Application Design and Build** with a weight of **20%**, but every
  page and lab in this repository teaches the topics of the CKAD
  **Application Deployment** domain (also 20%): deployment strategies,
  rolling updates, Helm and Kustomize. Keep the declared title until the
  maintainer decides; do not add Application Design and Build topics (images,
  workload kinds, multi-container pods, volumes) without asking.
- **What the exam really tests:** changing live Deployments, Services, Helm
  releases and Kustomize overlays by hand, under time pressure, and proving
  the result with `kubectl`. So the student must *do* things (switch a
  Service selector, tune a rollout, roll back, render an overlay, upgrade a
  release), not just recognise words. Every explanation should lead to
  something they can run, and every change should be proved with a check
  command (`kubectl get`, `rollout status`, JSONPath, `helm history`).
- **The exam topics (curriculum items of the Application Deployment
  domain):** use Kubernetes primitives to implement common deployment
  strategies (blue/green, canary); understand Deployments and how to perform
  rolling updates; use the Helm package manager to deploy existing packages;
  Kustomize.
- **The sections:**

  | Section | Title | Exam topic |
  | --- | --- | --- |
  | 010 | Blue-Green Deployments | Deployment strategies (blue/green) |
  | 020 | Rolling Updates And Rollbacks | Deployments and rolling updates |
  | 030 | Canary Deployments With Kustomize | Deployment strategies (canary), Kustomize |
  | 040 | Deploy Packages With Helm | Helm |

- **The version:** nothing pins a Kubernetes version. The lab runs on the
  single-node `kind` cluster that `astrona run` builds, with `kind`'s default
  Kubernetes version; the reading parts run on any practice cluster the
  learner has. The images are `nginx:1.30-alpine`, `nginx:1.31-alpine`,
  `nginx:1.32-alpine` and `nginx:1-alpine`. Helm is Helm 3 (the chart uses
  `apiVersion: v2`); Kustomize is the one built into `kubectl`
  (`kubectl kustomize`, `kubectl apply -k`). Do not teach behaviour that
  depends on one Kubernetes version without saying so (for example, from
  Kubernetes 1.33 `kubectl get endpoints` prints a warning that the v1
  Endpoints API is deprecated in favour of EndpointSlices; the command still
  works).
- **The main sources:** the Kubernetes documentation for Deployments,
  Services, labels and selectors, probes and Kustomize, and the Helm
  documentation. Check every page against them.

### Space analogy glossary

Use these pictures for these terms, in every course page and lab. Keep them
consistent so the astronaut builds one picture of the universe. It is the
same universe as the other Astrona courses (ATS000, ATS014, ATS015), so a
learner who moves on keeps the same pictures.

**The universe**

| Term | Space picture |
| --- | --- |
| The learner | An astronaut (a cadet on their first missions) |
| Kubernetes cluster | A solar system |
| `kind` cluster on your laptop | A training solar system in the simulator |
| Node | A launch pad: the place where ships are built and launched |
| Namespace | A planet in that solar system (the planets here are really named `venus`, `mercury` and so on) |
| Pod | A spaceship |
| Container | A module inside the ship (the app is the crew) |
| Container image / tag | The ship's blueprint / the version stamp on the blueprint |
| Control plane / API server | Mission control: it holds every order and reports on every ship |
| `kubectl` | Your radio to mission control |
| Request / response | A signal sent out, and the reply signal |
| Port | A radio channel |

**Fleets and how they change**

| Term | Space picture |
| --- | --- |
| Deployment | The fleet order: "keep this many ships of this design flying". It replaces a ship that breaks |
| `replicas` | How many ships the fleet order asks for |
| Pod template (`spec.template`) | The ship design inside the fleet order; change it and new ships are built |
| ReplicaSet | The batch of ships built from one version of the fleet order |
| Rollout / rolling update | Swapping the fleet for new ships a few at a time, while the fleet keeps flying |
| `maxSurge` | How many extra ships may be in the sky during the swap |
| `maxUnavailable` | How many ships of the ordered number may be out of service during the swap |
| Rollout history / revision | The fleet order's logbook: one numbered entry per ship design that was flown |
| `kubectl rollout undo` | Going back to an earlier logbook entry and flying that design again |
| Readiness probe | The pre-flight check: mission control sends signals to a ship only after it passes |
| Environment variable (`env`) | A note pinned up in the cockpit that the crew reads at launch |
| `kubectl set image`, `kubectl set env`, `kubectl patch` | Radioing one correction to one line of the fleet order |

**Beacons and traffic**

| Term | Space picture |
| --- | --- |
| Labels | Markings painted on a ship's hull (`app=web`, `version=blue`) |
| Kubernetes Service | A beacon: one call sign that a whole group of ships answers to |
| Service selector | The beacon's rule: which hull markings a ship needs to answer the call sign. Every marking must match |
| Endpoints / EndpointSlice | The beacon's current list of ship addresses that answer it |
| `NodePort` | A fixed docking port on every launch pad that leads to the beacon |
| Blue-green deployment | Two whole fleets in flight; the beacon points at one, and you swing it to the other in one move |
| Canary deployment | Sending a small scout group of new ships into the fleet first; their share of ships is their share of signals |

**Packing and shipping configuration**

| Term | Space picture |
| --- | --- |
| Kustomize base | The master star chart every mission starts from |
| Kustomize overlay | A clear sheet laid over the master chart with this mission's changes drawn on it |
| Patch (in an overlay) | One change drawn on the clear sheet |
| `kubectl kustomize` / `kubectl apply -k` | Looking through both layers at once / sending the combined chart to mission control |
| Helm | The shipyard's kit system |
| Chart | A ship kit: the parts (templates) plus a default order form (`values.yaml`) |
| Values (`--set`, `values.yaml`) | The options you tick on the kit's order form |
| Template | A kit part with blanks that the order form fills in |
| Release | One kit, built and flying under its own name on one planet |
| Release revision / `helm history` | The release's logbook: one entry per install, upgrade or rollback |
| Chart repository | The kit catalogue depot you order kits from |
| `pending-install` | A kit stuck half-built on the launch pad |

### The sample apps and environment

There is no shared fleet in this course. Each module has its own small app,
always the nginx web server. Use these names exactly as they are in the code:

| Module | Namespace (planet) | Objects | Notes |
| --- | --- | --- | --- |
| 010 / 01 (graded lab) | `venus` | Deployments `web-blue` and `web-green` (2 replicas each, container `nginx`), Service `web-svc` (port `80`) | Pod labels `app=web` plus `version=blue` or `version=green`. The Service starts with selector `app: web` only. `web-blue` runs `nginx:1.31-alpine`, `web-green` starts on `nginx:1.30-alpine` |
| 020 / 01 | `mercury` | Deployment `cassini` (4 replicas, container `app`, label `app=cassini`) | Image `nginx:1.31-alpine`; the target adds `maxSurge: 2`, `maxUnavailable: 0` and `APP_VERSION=2` |
| 020 / 02 | `aspen` | Deployment `api-new-c32` (2 replicas, container `api`) | Its readiness probe asks for `/missing` on port `80`, so the new pods never become ready |
| 030 / 01 | `tea-one`, `tea-two` | Deployments `tea` (label `track=stable`) and `tea-canary` (label `track=canary`), Service `tea` (type `NodePort`, `30020` and `30030`) | Image `nginx:1-alpine`. Kustomize trees `tea-one/` and `tea-two/`, each with `base/` and `overlays/prod/` |
| 040 / 01 | `helm-lab` | Local chart `study-web` (version `0.1.0`), release `study-web` | Values `replicaCount`, `image.repository`, `image.tag` (`1.31-alpine`), `service.port`; the upgrade goes to `1.32-alpine` |
| 040 / 02 | `birch` | Releases `internal-issue-report-apiv1`, `internal-issue-report-apiv2`, `internal-issue-report-apache` | Charts `study-charts/nginx` and `study-charts/apache` from a repository the reader's environment must provide |

The reading parts give every file the reader needs with "Save this as" (the
manifests, the Kustomize trees and the chart). The same files are kept in
each module's `examples/` folder as the authors' reference copy; pages never
tell the reader to apply from there.

### Environment facts the text must respect

- **One graded lab.** Only section 010 has a graded lab
  (`sections/section-010/module-01/labs/lab-01`, `metadata.name`
  `ast001-lab-010`; keep that name). Its `config.yaml` has no `apiVersion`,
  applies `manifests/` with `bootstrap.manifests`, and `astrona test` applies
  `solution/`.
- **The grader checks less than the task asks.** The lab's checks are a
  `resourceExists` check on `service/web-svc -n venus` and
  `validation/validate-service.sh`, which only checks that the `web-svc`
  selector has `version: blue`. It does not check the `web-green` image.
  `question.md` and `solution.md` must say exactly this.
- **No playgrounds.** No module has a playground yet, so pages have no
  `<!-- astrona:playground -->` or `<!-- astrona:playground:renew -->`
  markers, and missions have no stop or start step. The reading parts run on
  any practice cluster with `kubectl` (for example one made with
  `kind create cluster`). Helm must be installed on the reader's computer for
  section 040.
- **Every module cleans up its own planet.** Each module ends by deleting its
  namespace (`kubectl delete namespace mercury` and so on), or uninstalling
  the Helm release first.
- **The chart repository in module 040 / 02 is a placeholder.**
  `helm repo add study-charts https://example.invalid/charts` does not work
  as typed; the page must say the reader replaces the address with the chart
  repository of their own training cluster. Those commands are shown without
  output, because they have never run here.
- **The canary percentage is a pod count.** A Service spreads connections
  over all ready pods it selects, so 2 canary pods out of 10 get about 20% of
  the traffic. It is approximate, not an exact split.
- **A rollback needs history.** `kubectl rollout undo` needs an earlier
  revision; on a fresh cluster the reader must apply a working version
  before the broken one.

### Where things are in this repo

| What | Where |
| --- | --- |
| Course outline the platform reads: every reading page and lab, in order. Never list `solution.md` here | `astrona.yaml` |
| Overview, sections table, how to run things | `README.md` |
| How to contribute | `CONTRIBUTING.md` |
| Section overview and its modules | `sections/section-0N0/README.md` (plus `section.yaml` with the section's id, title and order) |
| Module reading: landing page, deep-dive parts, wrap-up | `sections/section-0N0/module-0M/course.md`, `course-0N-*.md` |
| Authors' reference copies of the files a module's pages ask the reader to save | `sections/section-0N0/module-0M/examples/` |
| Graded lab: task, walkthrough, setup, grader | `sections/section-010/module-01/labs/lab-01/` |

A lab folder holds:

| Path | Purpose |
| --- | --- |
| `config.yaml` | Lab definition; `metadata.docs` has `examQuestion: "question.md"` and `guide: "solution.md"` (`astrona validate` rejects the older `question` and `solution` keys) |
| `README.md` | Short intro with `estimated_duration` front matter and the run, submit and destroy commands |
| `question.md` | The exam-style task. Starts with `# Question` and `Solve this question on: \`terminal\`` |
| `solution.md` | Step-by-step walkthrough with real output |
| `manifests/` | Starting state, applied by `bootstrap.manifests`, never the graded end state |
| `solution/` | Reference end state, applied only by `astrona test` |
| `validation/` | Grading scripts |

### Lab metadata in `astrona.yaml`

`astrona.yaml` has one entry per section under `modules:` (`module-010`,
`module-020` and so on). Each section's `content` lists, in order: the
section `README.md`, then for each module its landing page, its parts, and
right after the part a lab tests, a `Question` reading
(`labs/lab-0N/question.md`) followed by the `type: lab` entry; the module's
wrap-up page comes last. A section capstone, when there is one, closes the
section. Playgrounds are not listed: the landing page's
`<!-- astrona:playground -->` marker shows them.

Every `type: lab` entry carries these fields, in this order:

```yaml
      - type: reading
        title: Question
        path: sections/section-010/module-01/labs/lab-01/question.md
      - type: lab
        title: "Blue-Green Service Switch Lab"
        path: sections/section-010/module-01/labs/lab-01
        difficulty: beginner
        estimated_duration: 15m
        topic: blue-green
        task_kind: migration
        tags: [blue-green, service-selector, labels, endpoints, kubectl-patch]
        learning_goals:
          - Find which pods a Service sends traffic to from its selector and endpoints
          - Switch a Service to one version by adding a label to its selector
        resources:
          - name: "Kubernetes Services"
            url: https://kubernetes.io/docs/concepts/services-networking/service/
```

- `difficulty`: `beginner`, `intermediate` or `advanced`.
- `estimated_duration`: realistic time to solve it, for example `15m`, `30m`, `45m`.
- `topic`: exactly one of `blue-green`, `rolling-update`, `rollback`,
  `canary`, `kustomize`, `helm`.
- `task_kind`: exactly one of `build` (write the configuration from
  scratch), `troubleshooting` (find and fix what is broken) or `migration`
  (move a working setup to another mode or layout, for example switching a
  Service from both versions to one). The platform filters labs by it, so it
  is a field of its own, never a tag.
- `tags`: 4 to 8 ids, only from the tag list below. Add a new tag to the list
  first if nothing fits.
- `learning_goals`: 2 or 3 plain sentences, each starting with a verb, saying
  what the learner proves in this lab.
- `resources`: 1 to 4 documentation pages, each with a `name` and a `url`
  that loads. This is the **only** place outside links are allowed: the
  platform shows them as optional further reading next to the lab.

**Tag list** (lower case, hyphens, never synonyms):

- Kubernetes objects: `namespace`, `pod`, `deployment`, `replicaset`,
  `service`, `nodeport`
- Labels and traffic: `labels`, `service-selector`, `endpoints`,
  `blue-green`, `canary`, `traffic-split`
- Rollouts: `pod-template`, `rollout-strategy`, `max-surge`,
  `max-unavailable`, `rollout-status`, `rollout-history`, `rollout-undo`,
  `readiness-probe`, `env-vars`, `image-tag`
- Kustomize: `kustomization`, `kustomize-base`, `kustomize-overlay`,
  `kustomize-patch`, `kubectl-kustomize`, `apply-k`
- Helm: `helm-chart`, `helm-values`, `helm-template`, `helm-lint`,
  `helm-install`, `helm-upgrade`, `helm-history`, `helm-rollback`,
  `helm-uninstall`, `helm-repo`, `pending-install`
- kubectl: `kubectl-set-image`, `kubectl-set-env`, `kubectl-patch`,
  `kubectl-edit`, `kubectl-apply`, `jsonpath`, `show-labels`
- Failure signatures: `no-endpoints`, `stuck-rollout`, `readiness-failure`

### Running things

```bash
# Lab (graded against the live cluster)
astrona run --git ssh://git@github.com/astrona-io/ATS001.git -c sections/section-010/module-01/labs/lab-01
astrona submit -c sections/section-010/module-01/labs/lab-01
astrona destroy ast001-lab-010   # takes metadata.name from config.yaml, not the path

# Authors: check the configuration, and prove the lab passes with its reference solution
astrona validate -c sections/section-010/module-01/labs/lab-01
astrona test -c sections/section-010/module-01/labs/lab-01
```

Names: the first lab is `ast001-lab-010`; keep that name. A playground is
`ats-001-playground-<section>-<module>`, and a new lab takes
`ats-001-lab-<section>-<module>-<lab>`, for example `ats-001-lab-020-01-01`,
so two labs never share a name. Lab bootstrap does not pin a kube context:
astrona sets `KUBECONFIG` for the lab. Every lab must pass
`astrona validate` and `astrona test`.

A lab's `question.md` and `solution.md` must match what its `validation/`
scripts and `config.yaml` checks actually check.

Test clusters on the maintainer's machine: one at a time. Podman has 10 GiB
and also runs the platform stack; parallel clusters run it out of memory.
Never touch clusters you did not create.

### Where to find trusted sources

Check facts here before writing them down. Prefer these over memory.

- **Deployments, rolling updates and rollbacks:**
  <https://kubernetes.io/docs/concepts/workloads/controllers/deployment/>
- **Services, labels and selectors:**
  <https://kubernetes.io/docs/concepts/services-networking/service/> and
  <https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/>
- **Readiness probes:**
  <https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/>
- **Kustomize:**
  <https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/>
- **Helm:** <https://helm.sh/docs/>, especially the chart template guide and
  the command reference for `helm install`, `upgrade`, `history`,
  `rollback`, `list` and `uninstall`
- **kubectl:** <https://kubernetes.io/docs/reference/kubectl/quick-reference/>
  and <https://kubernetes.io/docs/reference/kubectl/jsonpath/>
- **The exam itself:** the CKAD page on the Linux Foundation / CNCF training
  site, and the curriculum in <https://github.com/cncf/curriculum>. The
  domain name and weight above come from this repository's `astrona.yaml`
  and have not been re-checked against it.
- **The astrona tool:** `astrona --help` and `astrona <command> --help`.

### Skills to use here

The `astrona-course-*` skills do most authoring jobs in this repository: planning
(`domain-plan`), creating the tree (`domain-scaffold`), building modules
(`domain-build`), deep-dive parts (`deep-dive`), labs and playgrounds (`lab`),
lab docs (`lab-docs`), challenges (`create-challenge`), quizzes
(`generate-assessment`) and fact-checking (`review-accuracy`).
