# Written on the Wall II — Conjecture 109

## Classification

**DISPROVEN.** The exact Lean theorem is false.

The theorem claims that every finite connected simple graph satisfies

\[
\alpha(G) \le \left\lfloor\frac{\operatorname{residue}(G)+2b(G)}3\right\rfloor,
\]

where `b(G)` is the largest order of an induced bipartite subgraph.

## Counterexample

A connected graph on vertices `0,…,14` is given by the graph6 string

```text
NbA?IWS`yIIGFN[rI??
```

It has 37 edges. Its edge list is stored in `witness.edges`.

Exact invariants:

| invariant | value |
|---|---:|
| order | 15 |
| size | 37 |
| independence number `α(G)` | 8 |
| Havel–Hakimi residue `r(G)` | 3 |
| largest induced-bipartite order `b(G)` | 10 |

Therefore

\[
3\alpha(G)=24>23=r(G)+2b(G),
\]

and the theorem's right-hand side is

\[
\left\lfloor\frac{3+2\cdot10}{3}\right\rfloor
=\left\lfloor\frac{23}{3}\right\rfloor=7.
\]

The claimed conclusion specializes to `8 ≤ 7`, which is false.

## Exact certificates

A maximum independent set is

```text
{0, 2, 4, 6, 8, 10, 11, 14}.
```

It is the unique maximum independent set.

One maximum induced-bipartite vertex set is

```text
{0, 2, 3, 4, 6, 7, 8, 9, 10, 14}.
```

The degree sequence is

```text
[7, 7, 7, 7, 7, 7, 6, 5, 5, 4, 3, 3, 2, 2, 2].
```

Its Havel–Hakimi sequence terminates at `[0,0,0]`, giving residue 3. The complete trace is in `verifier.out`.

### Induced-bipartite upper-bound certificate

The graph contains 23 triangles. Their unique four-vertex transversal is

```text
{1, 5, 12, 13}.
```

After deleting those vertices, the five-cycle

```text
3—8—9—7—11—3
```

remains. Consequently, every odd-cycle transversal has at least five vertices, so every induced bipartite subgraph has at most `15−5=10` vertices. A ten-vertex induced bipartite subgraph exists, so `b(G)=10`.

## Independent verification

`verify_counterexample109_min.py` performs two independent exact computations for each difficult invariant:

- `α(G)` by exhaustive bitset search and by maximum cliques in the complement;
- `b(G)` by exhaustive bitset bipartiteness and by descending subset enumeration with NetworkX;
- residue by a direct Havel–Hakimi implementation.

It also checks the graph6 encoding, connectivity, the odd-cycle-transversal certificate, and all one-edge and one-vertex deletions. All assertions pass.

The canonical edge-list SHA-256 is

```text
fbe306dfb0be2603c5d8f05acf5f48b8d592010dbd10b2ce75d81f4b20225df6
```

## Adversarial review

Every one-edge deletion is still connected but has nonnegative margin

\[
r+2b-3\alpha\in\{0,2\}.
\]

Every one-vertex deletion is still connected and likewise has margin `0` or `2`. Thus this particular witness is locally minimal under single-edge deletion and single-vertex deletion. This does **not** prove that 15 is the minimum possible order or that 37 is the globally minimum number of edges.

Exhaustive connected-unlabeled-graph checks found no counterexample through eight vertices: all 995 connected graphs of orders 2–7 and all 11,117 connected graphs of order 8 satisfy the conjecture.

## Formal artifact

`../Counterexample109.lean` defines the executable 37-edge graph on `Fin 15`, proves connectivity, independence number 8, residue 3, formalizes the odd-cycle-transversal argument proving `b(G) ≤ 10`, and derives the negation of the exact floor inequality.

`../AxiomAudit.lean` reports the final theorem's axioms. GitHub Actions rejects placeholders and project-defined axiom declarations before accepting the formal certificate.

## Integrity notes

- The shared Formal Conjectures checkout was not modified.
- No claim of minimum counterexample order is made.
