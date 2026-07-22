import FormalConjecturesUtil

/-!
# Counterexample to Written on the Wall II, Conjecture 109

This file is independent of the conjecture theorem itself. It defines a connected graph on
`Fin 15`, proves that its independence number is eight and its Havel--Hakimi residue is three,
and proves that every induced bipartite subgraph has at most ten vertices. Consequently the
formal inequality in `GraphConjecture109.lean` specializes to `8 ≤ 7`.

The graph6 encoding of the witness is `NbA?IWS`yIIGFN[rI??`.
-/

namespace WrittenOnTheWallII.GraphConjecture109.Counterexample

open SimpleGraph

/-- The 37 edges, in one orientation, as an executable Boolean predicate. -/
def edgeForward (u v : Fin 15) : Bool :=
  (u.val == 0 && v.val == 1) || (u.val == 0 && v.val == 5) ||
  (u.val == 0 && v.val == 9) ||
  (u.val == 1 && v.val == 3) || (u.val == 1 && v.val == 7) ||
  (u.val == 1 && v.val == 10) || (u.val == 1 && v.val == 11) ||
  (u.val == 1 && v.val == 13) || (u.val == 1 && v.val == 14) ||
  (u.val == 2 && v.val == 3) || (u.val == 2 && v.val == 13) ||
  (u.val == 3 && v.val == 8) || (u.val == 3 && v.val == 11) ||
  (u.val == 3 && v.val == 12) || (u.val == 3 && v.val == 13) ||
  (u.val == 3 && v.val == 14) ||
  (u.val == 4 && v.val == 7) || (u.val == 4 && v.val == 12) ||
  (u.val == 5 && v.val == 6) || (u.val == 5 && v.val == 7) ||
  (u.val == 5 && v.val == 8) || (u.val == 5 && v.val == 9) ||
  (u.val == 5 && v.val == 10) || (u.val == 5 && v.val == 12) ||
  (u.val == 6 && v.val == 9) || (u.val == 6 && v.val == 13) ||
  (u.val == 7 && v.val == 9) || (u.val == 7 && v.val == 10) ||
  (u.val == 7 && v.val == 11) || (u.val == 7 && v.val == 13) ||
  (u.val == 8 && v.val == 9) || (u.val == 8 && v.val == 12) ||
  (u.val == 9 && v.val == 12) ||
  (u.val == 10 && v.val == 12) || (u.val == 10 && v.val == 13) ||
  (u.val == 11 && v.val == 12) || (u.val == 11 && v.val == 13)

/-- The symmetric executable adjacency predicate. -/
def edgeBool (u v : Fin 15) : Bool := edgeForward u v || edgeForward v u

/-- A 15-vertex, 37-edge counterexample. -/
def witness : SimpleGraph (Fin 15) :=
  SimpleGraph.mk' ⟨edgeBool, by
    constructor <;> native_decide⟩

instance witnessDecidableAdj : DecidableRel witness.Adj := fun u v => by
  change Decidable (edgeBool u v = true)
  infer_instance

open Classical

/-- The unique maximum independent set of the witness. -/
def maxIndependent : Finset (Fin 15) := {0, 2, 4, 6, 8, 10, 11, 14}

set_option maxHeartbeats 0 in
lemma witness_connected : witness.Connected := by
  native_decide

set_option maxHeartbeats 0 in
lemma witness_isMaximumIndepSet : witness.IsMaximumIndepSet maxIndependent := by
  constructor
  · native_decide
  · intro t ht
    have h : ∀ t : Finset (Fin 15), witness.IsIndepSet t → t.card ≤ 8 := by
      native_decide
    exact h t ht

lemma witness_indepNum : witness.indepNum = 8 := by
  rw [← witness.maximumIndepSet_card_eq_indepNum maxIndependent witness_isMaximumIndepSet]
  native_decide

set_option maxHeartbeats 0 in
lemma witness_residue : residue witness = 3 := by
  unfold residue
  decide +native

/-
## A finite odd-cycle-transversal certificate

The 23 triangles below have a unique four-vertex transversal `{1,5,12,13}`. The remaining
five-cycle `3-8-9-7-11-3` avoids that transversal. Hence every set meeting all listed odd cycles
has at least five vertices. This is a compact certificate that deleting only four vertices can
never make the witness bipartite.
-/

def triangles : Finset (Finset (Fin 15)) :=
  { {0, 5, 9},
    {1, 3, 11}, {1, 3, 13}, {1, 3, 14},
    {1, 7, 10}, {1, 7, 11}, {1, 7, 13},
    {1, 10, 13}, {1, 11, 13},
    {2, 3, 13},
    {3, 8, 12}, {3, 11, 12}, {3, 11, 13},
    {5, 6, 9}, {5, 7, 9}, {5, 7, 10},
    {5, 8, 9}, {5, 8, 12}, {5, 9, 12}, {5, 10, 12},
    {7, 10, 13}, {7, 11, 13},
    {8, 9, 12} }

def fiveCycle : Finset (Fin 15) := {3, 8, 9, 7, 11}

def forbiddenOddCycles : Finset (Finset (Fin 15)) := insert fiveCycle triangles

/- A purely finite check: every transversal of the listed odd cycles has size at least five. -/
set_option maxHeartbeats 0 in
lemma forbiddenOddCycles_hittingNumber :
    ∀ t : Finset (Fin 15),
      (∀ c ∈ forbiddenOddCycles, (c ∩ t).Nonempty) → 5 ≤ t.card := by
  native_decide

/- Every listed forbidden set is either the designated five-cycle or a triangle of `witness`. -/
set_option maxHeartbeats 0 in
lemma forbiddenOddCycles_shape :
    ∀ c ∈ forbiddenOddCycles,
      c = fiveCycle ∨
        (c.card = 3 ∧
          ∀ u ∈ c, ∀ v ∈ c, u ≠ v → witness.Adj u v) := by
  native_decide

lemma finTwo_eq_of_ne_of_ne (a b c : Fin 2) (hab : a ≠ b) (hbc : b ≠ c) : a = c := by
  fin_cases a <;> fin_cases b <;> fin_cases c <;> simp_all

/-- A two-coloring cannot contain the explicit five-cycle. -/
lemma fiveCycle_not_bipartite (s : Finset (Fin 15)) (hsub : fiveCycle ⊆ s) :
    ¬(witness.induce s).IsBipartite := by
  rintro ⟨C⟩
  let v3 : ↥s := ⟨3, hsub (by native_decide)⟩
  let v8 : ↥s := ⟨8, hsub (by native_decide)⟩
  let v9 : ↥s := ⟨9, hsub (by native_decide)⟩
  let v7 : ↥s := ⟨7, hsub (by native_decide)⟩
  let v11 : ↥s := ⟨11, hsub (by native_decide)⟩
  have h38 : C v3 ≠ C v8 := C.valid (by
    change witness.Adj 3 8
    native_decide)
  have h89 : C v8 ≠ C v9 := C.valid (by
    change witness.Adj 8 9
    native_decide)
  have h97 : C v9 ≠ C v7 := C.valid (by
    change witness.Adj 9 7
    native_decide)
  have h711 : C v7 ≠ C v11 := C.valid (by
    change witness.Adj 7 11
    native_decide)
  have h113 : C v11 ≠ C v3 := C.valid (by
    change witness.Adj 11 3
    native_decide)
  have h39 : C v3 = C v9 := finTwo_eq_of_ne_of_ne _ _ _ h38 h89
  have h911 : C v9 = C v11 := finTwo_eq_of_ne_of_ne _ _ _ h97 h711
  exact h113 (h911.symm.trans h39.symm)

/-- Every induced bipartite subgraph of the witness has at most ten vertices. -/
lemma bipartite_card_le_ten (s : Finset (Fin 15))
    (hs : (witness.induce s).IsBipartite) : s.card ≤ 10 := by
  let t : Finset (Fin 15) := Finset.univ \ s
  have hhit : ∀ c ∈ forbiddenOddCycles, (c ∩ t).Nonempty := by
    intro c hc
    by_contra hn
    have hcsub : c ⊆ s := by
      intro v hv
      by_contra hvs
      apply hn
      exact ⟨v, by simp [t, hv, hvs]⟩
    rcases forbiddenOddCycles_shape c hc with hfive | ⟨hcard, hadj⟩
    · subst c
      exact fiveCycle_not_bipartite s hcsub hs
    · let e : Fin 3 ≃ ↥c := (Finset.equivFinOfCardEq hcard).symm
      let f : Fin 3 → ↥s := fun i => ⟨(e i).1, hcsub (e i).2⟩
      have hf : Pairwise fun i j : Fin 3 => (witness.induce s).Adj (f i) (f j) := by
        intro i j hij
        change witness.Adj (e i).1 (e j).1
        apply hadj (e i).1 (e i).2 (e j).1 (e j).2
        intro hval
        apply hij
        exact e.injective (Subtype.ext hval)
      have hle : Nat.card (Fin 3) ≤ 2 := hs.card_le_of_pairwise_adj f hf
      norm_num at hle
  have ht : 5 ≤ t.card := forbiddenOddCycles_hittingNumber t hhit
  have htcard : t.card = 15 - s.card := by
    dsimp [t]
    rw [Finset.card_sdiff]
    simp
  omega

lemma largestInducedBipartiteSubgraphSize_le_ten :
    largestInducedBipartiteSubgraphSize witness ≤ 10 := by
  unfold largestInducedBipartiteSubgraphSize
  apply csSup_le
  · refine ⟨0, ?_⟩
    refine ⟨∅, ?_, rfl⟩
    refine ⟨⟨fun v => False.elim (by simpa using v.property), ?_⟩⟩
    intro v w _
    exact False.elim (by simpa using v.property)
  · rintro n ⟨s, hs, rfl⟩
    exact bipartite_card_le_ten s hs

lemma witness_b_le_ten : b witness ≤ 10 := by
  unfold b
  exact_mod_cast largestInducedBipartiteSubgraphSize_le_ten

/-- The exact formal inequality of Conjecture 109 fails on `witness`. -/
theorem not_conjecture109 :
    ¬((witness.indepNum : ℝ) ≤ ⌊((residue witness : ℝ) + 2 * b witness) / 3⌋) := by
  intro hconj
  rw [witness_indepNum, witness_residue] at hconj
  have hx : ((3 : ℝ) + 2 * b witness) / 3 < 8 := by
    linarith [witness_b_le_ten]
  have hfloorZ : ⌊((3 : ℝ) + 2 * b witness) / 3⌋ < (8 : ℤ) :=
    (Int.floor_lt).2 hx
  have hfloorR :
      ((⌊((3 : ℝ) + 2 * b witness) / 3⌋ : ℤ) : ℝ) < 8 := by
    exact_mod_cast hfloorZ
  exact (not_le_of_gt hfloorR) hconj

/-- Therefore the connected-graph universal statement on `Fin 15` is false. -/
theorem conjecture109_is_false :
    ¬(∀ (G : SimpleGraph (Fin 15)) [DecidableRel G.Adj], G.Connected →
      (G.indepNum : ℝ) ≤ ⌊((residue G : ℝ) + 2 * b G) / 3⌋) := by
  intro h
  exact not_conjecture109 (h witness witness_connected)

end WrittenOnTheWallII.GraphConjecture109.Counterexample
