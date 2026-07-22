import Counterexample109

/-!
# Axiom audit for the WOW II Conjecture 109 counterexample

This module contributes no proof. It asks Lean to report the axioms of the final refutation theorem.
CI separately rejects `sorry`, `admit`, `sorryAx`, and project-defined `axiom` declarations.
-/

#check WrittenOnTheWallII.GraphConjecture109.Counterexample.conjecture109_is_false
#print axioms WrittenOnTheWallII.GraphConjecture109.Counterexample.conjecture109_is_false
