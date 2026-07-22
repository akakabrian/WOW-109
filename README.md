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

## Verification gates

GitHub Actions must complete all of the following on the final branch head:

1. Reject `sorry`, `admit`, or project-defined `axiom` declarations in the Lean source files.
2. Kernel-check `Counterexample109` with the pinned Lean environment.
3. Compile `AxiomAudit109.lean` and record the `#print axioms` output.
4. Reject `sorryAx` in the axiom audit.
5. Upload the build and axiom-audit logs.

The core counterexample target first passed the Lean kernel in Actions run 22. The final evidence-and-audit branch head must also pass all gates before the formal package is declared complete.

The pull request remains a draft and is not merged automatically.

## Scope and integrity

The witness is locally minimal under any single edge deletion or single vertex deletion, but no claim is made that 15 is the minimum possible order or that 37 is the global minimum number of edges. The shared Formal Conjectures checkout was not modified.

## Provenance

The counterexample was found through computational graph search and independently rechecked by separate exact algorithms. AI systems assisted with the search, adversarial verification, Lean API work, and CI iteration. The final formal claim is accepted only when the pinned Lean kernel and axiom-audit workflow pass.
