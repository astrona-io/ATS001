---
estimated_duration: 15m
---

# Blue-Green Service Switch Lab

Astronaut, two versions of one web app run side by side on the planet `venus`, and a Service sends traffic to both. In this mission you update the green version's image and then switch the Service so only the blue version gets traffic. It takes about 15 minutes.

## Launching the Lab

Start the lab and read the task:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS001.git -c sections/section-010/module-01/labs/lab-01
astrona docs question
```

When you think you have finished, send it for grading:

```sh
astrona submit -c sections/section-010/module-01/labs/lab-01
```

When you are done, remove the lab:

```sh
astrona destroy ast001-lab-010
```

For authors: `astrona validate -c .` and `astrona test -c .` (the reference solution in `solution/` must pass every check).
