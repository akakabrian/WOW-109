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

- `Counterexample109.lean` defines the graph and proves the refutation theorem
  `WrittenOnTheWallII.GraphConjecture109.Counterexample.conjecture109_is_false`.
- `AxiomAudit109.lean` runs `#print axioms` on that theorem.
- `evidence/GraphConjecture109-counterexample.g6` contains the graph6 witness.
- `evidence/GraphConjecture109-counterexample.edges` contains the explicit 37-edge list.
- `evidence/verification.md` records the independent exact checks and structural certificate.

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
```

## CI verification gates

GitHub Actions must complete all of the following:

1. Kernel-check `Counterexample109` with the pinned Lean environment.
2. Reject `sorry`, `admit`, or project-defined `axiom` declarations in the two Lean source files.
3. Compile `AxiomAudit109.lean` and record the `#print axioms` output.
4. Reject `sorryAx` in the axiom audit.
5. Upload both the build log and axiom-audit log.

The pull request remains a draft and is not merged automatically.

## Provenance

The counterexample was found through computational graph search and then independently rechecked by separate exact algorithms. AI systems assisted with the search, adversarial verification, Lean API work, and CI iteration. The final formal claim is accepted only when the pinned Lean kernel and axiom-audit workflow pass.
