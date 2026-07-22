#!/usr/bin/env python3
"""Independent exact verifier for the minimized counterexample to WOW II Conjecture 109."""
from __future__ import annotations

from itertools import combinations
import hashlib
import json
import networkx as nx

N = 15
GRAPH6_EXPECTED = "NbA?IWS`yIIGFN[rI??"
EDGES = [
    (0,1), (0,5), (0,9),
    (1,3), (1,7), (1,10), (1,11), (1,13), (1,14),
    (2,3), (2,13),
    (3,8), (3,11), (3,12), (3,13), (3,14),
    (4,7), (4,12),
    (5,6), (5,7), (5,8), (5,9), (5,10), (5,12),
    (6,9), (6,13),
    (7,9), (7,10), (7,11), (7,13),
    (8,9), (8,12),
    (9,12),
    (10,12), (10,13),
    (11,12), (11,13),
]


def make_graph(edges=EDGES, vertices=range(N)) -> nx.Graph:
    g = nx.Graph()
    g.add_nodes_from(vertices)
    g.add_edges_from(edges)
    return g


def adjacency_masks(g: nx.Graph, order: list[int]) -> list[int]:
    index = {v: i for i, v in enumerate(order)}
    masks = [0] * len(order)
    for u, v in g.edges():
        if u in index and v in index:
            a, b = index[u], index[v]
            masks[a] |= 1 << b
            masks[b] |= 1 << a
    return masks


def independent(mask: int, adj: list[int]) -> bool:
    x = mask
    while x:
        bit = x & -x
        v = bit.bit_length() - 1
        x ^= bit
        if adj[v] & x:
            return False
    return True


def bipartite(mask: int, adj: list[int]) -> bool:
    color = [-1] * len(adj)
    remaining = mask
    while remaining:
        start_bit = remaining & -remaining
        start = start_bit.bit_length() - 1
        color[start] = 0
        stack = [start]
        remaining ^= start_bit
        while stack:
            u = stack.pop()
            nbrs = adj[u] & mask
            while nbrs:
                bit = nbrs & -nbrs
                v = bit.bit_length() - 1
                nbrs ^= bit
                if color[v] < 0:
                    color[v] = color[u] ^ 1
                    stack.append(v)
                    remaining &= ~bit
                elif color[v] == color[u]:
                    return False
    return True


def exact_alpha_bitset(g: nx.Graph) -> tuple[int, list[int], int]:
    order = sorted(g.nodes())
    adj = adjacency_masks(g, order)
    best = 0
    witnesses: list[int] = []
    for mask in range(1 << len(order)):
        size = mask.bit_count()
        if size < best:
            continue
        if independent(mask, adj):
            if size > best:
                best, witnesses = size, []
            witnesses.append(mask)
    first = [order[i] for i in range(len(order)) if witnesses[0] >> i & 1]
    return best, first, len(witnesses)


def exact_b_bitset(g: nx.Graph) -> tuple[int, list[int], int]:
    order = sorted(g.nodes())
    adj = adjacency_masks(g, order)
    best = 0
    witnesses: list[int] = []
    for mask in range(1 << len(order)):
        size = mask.bit_count()
        if size < best:
            continue
        if bipartite(mask, adj):
            if size > best:
                best, witnesses = size, []
            witnesses.append(mask)
    first = [order[i] for i in range(len(order)) if witnesses[0] >> i & 1]
    return best, first, len(witnesses)


def exact_alpha_networkx(g: nx.Graph) -> int:
    return max(map(len, nx.find_cliques(nx.complement(g))), default=0)


def exact_b_networkx(g: nx.Graph) -> int:
    vertices = list(g.nodes())
    for k in range(len(vertices), -1, -1):
        for subset in combinations(vertices, k):
            if nx.is_bipartite(g.subgraph(subset)):
                return k
    raise AssertionError("unreachable")


def havel_hakimi_residue(g: nx.Graph) -> tuple[int, list[list[int]]]:
    seq = sorted((d for _, d in g.degree()), reverse=True)
    trace = [seq.copy()]
    while seq and seq[0] != 0:
        d, rest = seq[0], seq[1:]
        assert d <= len(rest), (d, rest)
        rest[:d] = [x - 1 for x in rest[:d]]
        assert min(rest, default=0) >= 0
        seq = sorted(rest, reverse=True)
        trace.append(seq.copy())
    return len(seq), trace


def invariants(g: nx.Graph) -> tuple[int, int, int]:
    a, _, _ = exact_alpha_bitset(g)
    r, _ = havel_hakimi_residue(g)
    b, _, _ = exact_b_bitset(g)
    return a, r, b


def main() -> None:
    g = make_graph()
    assert nx.is_connected(g)
    encoded = nx.to_graph6_bytes(g, header=False).decode().strip()
    assert encoded == GRAPH6_EXPECTED, (encoded, GRAPH6_EXPECTED)

    alpha1, independent_set, alpha_count = exact_alpha_bitset(g)
    alpha2 = exact_alpha_networkx(g)
    b1, bipartite_set, b_count = exact_b_bitset(g)
    b2 = exact_b_networkx(g)
    residue, hh_trace = havel_hakimi_residue(g)

    assert alpha1 == alpha2 == 8
    assert residue == 3
    assert b1 == b2 == 10
    assert independent_set == [0,2,4,6,8,10,11,14]
    assert set(bipartite_set) == {0,2,3,4,6,7,8,9,10,14}

    numerator = residue + 2 * b1
    rhs = numerator // 3
    assert numerator == 23 and rhs == 7 and alpha1 > rhs

    triangles = [tuple(c) for c in combinations(range(N), 3)
                 if g.subgraph(c).number_of_edges() == 3]
    triangle_transversals = [
        t for t in combinations(range(N), 4)
        if all(set(t) & set(c) for c in triangles)
    ]
    assert triangle_transversals == [(1, 5, 12, 13)]
    five_cycle = (3, 8, 9, 7, 11)
    assert all(g.has_edge(five_cycle[i], five_cycle[(i + 1) % 5]) for i in range(5))
    forbidden = triangles + [five_cycle]
    assert not any(all(set(t) & set(c) for c in forbidden)
                   for t in combinations(range(N), 4))
    assert any(all(set(t) & set(c) for c in forbidden)
               for t in combinations(range(N), 5))

    edge_deletion_results = []
    for e in EDGES:
        h = g.copy()
        h.remove_edge(*e)
        if not nx.is_connected(h):
            edge_deletion_results.append((e, "disconnected", None))
            continue
        a, r, b = invariants(h)
        edge_deletion_results.append((e, "connected", r + 2*b - 3*a))
    assert all(status == "disconnected" or margin >= 0
               for _, status, margin in edge_deletion_results)

    vertex_deletion_results = []
    for v in range(N):
        h = g.copy()
        h.remove_node(v)
        if not nx.is_connected(h):
            vertex_deletion_results.append((v, "disconnected", None))
            continue
        a, r, b = invariants(h)
        vertex_deletion_results.append((v, "connected", r + 2*b - 3*a))
    assert all(status == "disconnected" or margin >= 0
               for _, status, margin in vertex_deletion_results)

    canonical_edges = json.dumps(EDGES, separators=(",", ":"))
    digest = hashlib.sha256(canonical_edges.encode()).hexdigest()

    print("WOW II Conjecture 109 minimized counterexample verification")
    print(f"graph6: {encoded}")
    print(f"edge-list SHA-256: {digest}")
    print(f"order: {g.number_of_nodes()}")
    print(f"size: {g.number_of_edges()}")
    print(f"connected: {nx.is_connected(g)}")
    print(f"degree sequence: {sorted((d for _, d in g.degree()), reverse=True)}")
    print(f"alpha (bitset brute force): {alpha1}")
    print(f"alpha (max cliques of complement): {alpha2}")
    print(f"maximum independent set: {independent_set}")
    print(f"number of maximum independent sets: {alpha_count}")
    print(f"residue: {residue}")
    print("Havel-Hakimi trace:")
    for row in hh_trace:
        print("  " + str(row))
    print(f"b (bitset brute force): {b1}")
    print(f"b (subset + NetworkX bipartiteness): {b2}")
    print(f"one maximum induced-bipartite set: {bipartite_set}")
    print(f"number of maximum induced-bipartite sets: {b_count}")
    print(f"triangles: {len(triangles)}")
    print(f"unique size-4 triangle transversal: {triangle_transversals[0]}")
    print(f"extra five-cycle: {five_cycle}")
    print("minimum transversal of the 23 triangles plus five-cycle: 5")
    print(f"integer form: 3*alpha = {3*alpha1}; residue + 2*b = {numerator}")
    print(f"formal RHS floor: floor(({residue} + 2*{b1})/3) = {rhs}")
    print(f"violation: {alpha1} <= {rhs} is FALSE")
    print("single-edge deletion margins:")
    for item in edge_deletion_results:
        print("  " + repr(item))
    print("single-vertex deletion margins:")
    for item in vertex_deletion_results:
        print("  " + repr(item))
    print("ALL ASSERTIONS PASSED")


if __name__ == "__main__":
    main()
