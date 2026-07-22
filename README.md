# WOW-109 Counterexample Verification

This repository contains a Lean-verified refutation artifact for Written on the Wall II Conjecture 109.

## CI

GitHub Actions runs Lean verification on every push and pull request.

Required artifact:

```
Counterexample109.lean
```

Run locally:

```bash
lake env lean Counterexample109.lean
```
