# Independent verification evidence

## Witness

- Vertex set: `0, …, 14`
- Number of edges: `37`
- graph6: ``NbA?IWS`yIIGFN[rI??``
- Edge-list SHA-256: `fbe306dfb0be2603c5d8f05acf5f48b8d592010dbd10b2ce75d81f4b20225df6`

The executable adjacency predicate in `Counterexample109.lean` was compared against the edge list in this directory. All 37 edges agree, with no missing or additional edges.

## Exact invariants

For the connected witness graph `G`:

- Independence number: `α(G) = 8`.
- Havel–Hakimi residue: `r(G) = 3`.
- Largest induced-bipartite order: `b(G) = 10`.

The independence number was checked by exhaustive bitset enumeration of all vertex subsets and independently as the clique number of the complement. The induced-bipartite order was checked by two separate exhaustive algorithms over all vertex subsets. The Havel–Hakimi residue was checked by recording the complete reduction trace from the descending degree sequence.

Thus

```text
3 α(G) = 24
r(G) + 2 b(G) = 3 + 20 = 23
```

and the exact formal bound specializes to

```text
8 ≤ floor(23 / 3) = 7,
```

which is false.

## Structural certificate for `b(G) ≤ 10`

The graph has 23 triangles. Their unique four-vertex transversal is

```text
{1, 5, 12, 13}.
```

Deleting those four vertices still leaves the odd cycle

```text
3 — 8 — 9 — 7 — 11 — 3.
```

Therefore deleting any four vertices cannot leave a bipartite induced graph. At least five vertices must be removed, so an induced bipartite subgraph has at most `15 - 5 = 10` vertices. The Lean certificate also exhibits the corresponding finite odd-cycle-transversal argument.

## Scope

The witness is locally minimal under a single edge deletion and a single vertex deletion in the independent search. No claim is made that 15 is the globally minimum possible counterexample order.
