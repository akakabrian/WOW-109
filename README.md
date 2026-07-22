# WOW II Conjecture 109 — formal counterexample

This repository contains an explicit connected counterexample to the exact Lean statement of Written on the Wall II Conjecture 109.

For the 15-vertex witness `G`:

```text
independence number α(G)       = 8
Havel–Hakimi residue r(G)      = 3
largest induced-bipartite b(G) = 10
```

Therefore

```text
3 α(G) = 24 > 23 = r(G) + 2 b(G),
```

so the formal inequality specializes to `8 ≤ floor(23 / 3) = 7`.

## Relationship to other counterexamples

This repository is an **independent formal corroboration**, not a priority or minimality claim.

- Upstream PR [#4494](https://github.com/google-deepmind/formal-conjectures/pull/4494) was merged first and marked the conjecture disproved using a different 21-vertex counterexample.
- Open upstream PR [#4495](https://github.com/google-deepmind/formal-conjectures/pull/4495) gives a smaller 13-vertex counterexample and an infinite counterexample family.
- The 15-vertex witness here was found and verified independently. It remains useful as a separate check of the formal definitions and as a compact odd-cycle-transversal certificate.

## Formal artifacts

- `Counterexample109.lean` defines the executable 37-edge graph and proves the refutation theorem
  `WrittenOnTheWallII.GraphConjecture109.Counterexample.conjecture109_is_false`.
- `AxiomAudit109.lean` runs `#print axioms` on that theorem.
- `evidence/witness.g6` contains the graph6 witness.
- `evidence/witness.edges` contains the explicit edge list.
- `evidence/COUNTEREXAMPLE.md` gives the mathematical and structural certificate.
- `evidence/verify_counterexample109_min.py` independently recomputes the invariants using two exact methods for both `α(G)` and `b(G)`.
- `evidence/verifier.out` records the successful verifier run.

## Reproducible environment

The project pins:

- Lean `v4.27.0` through `lean-toolchain`;
- `google-deepmind/formal-conjectures` at commit
  `e923379e609b9d5987011a1d1f06ec22ea25cd20`;
- the complete transitive Lake dependency graph in `lake-manifest.json`.

Run locally with:

```bash
lake build Counterexample109
lake env lean AxiomAudit109.lean
python3 evidence/verify_counterexample109_min.py
```

## Completed verification gates

GitHub Actions completed all of the following successfully on the final proof branch head:

1. Rejected `sorry`, `admit`, and project-defined `axiom` declarations in the Lean source files.
2. Kernel-checked `Counterexample109` with the pinned Lean environment.
3. Compiled `AxiomAudit109.lean` and recorded the `#print axioms` output.
4. Confirmed that the final theorem does not depend on `sorryAx`.
5. Uploaded the build and axiom-audit logs.

The complete final verification was [Actions run 40](https://github.com/akakabrian/WOW-109/actions/runs/29907800098). The verified package was squash-merged into `main` as commit [`6964ac6`](https://github.com/akakabrian/WOW-109/commit/6964ac6d95d8405d56c389ed54eab821842cd82a).

## Scope and integrity

The witness is locally minimal under any single edge deletion or single vertex deletion, but it is not the smallest known counterexample. No claim is made that 37 is the globally minimum number of edges. The shared Formal Conjectures checkout was not modified.

## Provenance

The counterexample was found through computational graph search and independently rechecked by separate exact algorithms. AI systems assisted with the search, adversarial verification, Lean API work, and CI iteration. The formal claim was accepted only after the pinned Lean build and axiom-audit workflow passed.
