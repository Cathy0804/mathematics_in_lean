import MIL.Common
import Mathlib.Topology.MetricSpace.Basic

section
variable {α : Type*} [PartialOrder α]
variable (x y z : α)

#check x ≤ y
#check (le_refl x : x ≤ x)
#check (le_trans : x ≤ y → y ≤ z → x ≤ z)
#check (le_antisymm : x ≤ y → y ≤ x → x = y)


#check x < y
#check (lt_irrefl x : ¬ (x < x))
#check (lt_trans : x < y → y < z → x < z)
#check (lt_of_le_of_lt : x ≤ y → y < z → x < z)
#check (lt_of_lt_of_le : x < y → y ≤ z → x < z)

example : x < y ↔ x ≤ y ∧ x ≠ y :=
  lt_iff_le_and_ne

end

section
variable {α : Type*} [Lattice α]
variable (x y z : α)

#check x ⊓ y
#check (inf_le_left : x ⊓ y ≤ x)
#check (inf_le_right : x ⊓ y ≤ y)
#check (le_inf : z ≤ x → z ≤ y → z ≤ x ⊓ y)
#check x ⊔ y
#check (le_sup_left : x ≤ x ⊔ y)
#check (le_sup_right : y ≤ x ⊔ y)
#check (sup_le : x ≤ z → y ≤ z → x ⊔ y ≤ z)

example : x ⊓ y = y ⊓ x := by
  apply le_antisymm
  repeat
    apply le_inf
    · apply inf_le_right
    · apply inf_le_left

example : x ⊓ y ⊓ z = x ⊓ (y ⊓ z) := by
  apply le_antisymm -- activates double-inclusion
  -- sub-goal: LHS ≤ RHS
  · apply le_inf -- WTS LHS ≤ x and LHS ≤ y ⊓ z
    -- Pre-requisite 1: LHS ≤ x
    · trans x ⊓ y -- creating a transmission LHS ≤ (x ⊓ y) ≤ x by providing the pre-requisites
      apply inf_le_left -- given LHS ≤ x ⊓ y
      apply inf_le_left -- and x ⊓ y ≤ x
    -- Pre-requisite 2: LHS ≤ y ⊓ z
    · apply le_inf -- WTS LHS ≤ y and LHS ≤ z by providing pre-requisites
      · trans x ⊓ y -- creating a transmission LHS ≤ (x ⊓ y) ≤ y by providing the pre-requisites
        apply inf_le_left -- given LHS ≤ x ⊓ y
        apply inf_le_right -- and x ⊓ y ≤ y
      · apply inf_le_right -- LHS ≤ z by respective lemma
  -- sub-goal: RHS ≤ LHS
  · apply le_inf -- WTS RHS ≤ x ⊓ y and RHS ≤ z
    -- Pre-requisite 1: RHS ≤ x ⊓ y
    · apply le_inf -- WTS RHS ≤ x and RHS ≤ y
      · apply inf_le_left -- RHS ≤ x by respective lemma
      · trans y ⊓ z -- creating a transmission RHS ≤ (y ⊓ z) ≤ y by providing the pre-requisites
        apply inf_le_right -- given RHS ≤ y ⊓ z
        apply inf_le_left -- and y ⊓ z ≤ y
    -- Pre-requisite 2: RHS ≤ z
    · trans y ⊓ z -- creating a transmission RHS ≤ (y ⊓ z) ≤ z by providing the pre-requisites
      apply inf_le_right -- given RHS ≤ y ⊓ z
      apply inf_le_right -- and y ⊓ z ≤ z

example : x ⊔ y = y ⊔ x := by
  apply le_antisymm
  repeat
    apply sup_le
    apply le_sup_right
    apply le_sup_left

example : x ⊔ y ⊔ z = x ⊔ (y ⊔ z) := by
  apply le_antisymm
  · apply sup_le
    · apply sup_le
      · apply le_sup_left
      · trans y ⊔ z
        apply le_sup_left
        apply le_sup_right
    · trans y ⊔ z
      apply le_sup_right
      apply le_sup_right
  · apply sup_le
    · trans x ⊔ y
      apply le_sup_left
      apply le_sup_left
    · apply sup_le
      · trans x ⊔ y
        apply le_sup_right
        apply le_sup_left
      · apply le_sup_right

theorem absorb1 : x ⊓ (x ⊔ y) = x := by
  apply le_antisymm
  · apply inf_le_left
  · apply le_inf
    · apply le_refl
    · apply le_sup_left

theorem absorb2 : x ⊔ x ⊓ y = x := by
  apply le_antisymm
  · apply sup_le
    · apply le_refl
    · apply inf_le_left
  · apply le_sup_left

end

section
variable {α : Type*} [DistribLattice α]
variable (x y z : α)

#check (inf_sup_left x y z : x ⊓ (y ⊔ z) = x ⊓ y ⊔ x ⊓ z)
#check (inf_sup_right x y z : (x ⊔ y) ⊓ z = x ⊓ z ⊔ y ⊓ z)
#check (sup_inf_left x y z : x ⊔ y ⊓ z = (x ⊔ y) ⊓ (x ⊔ z))
#check (sup_inf_right x y z : x ⊓ y ⊔ z = (x ⊔ z) ⊓ (y ⊔ z))
end

section
variable {α : Type*} [Lattice α]
variable (a b c : α)

example (h : ∀ x y z : α, x ⊓ (y ⊔ z) = x ⊓ y ⊔ x ⊓ z) : a ⊔ b ⊓ c = (a ⊔ b) ⊓ (a ⊔ c) := by
  rw [h]
  nth_rw 2 [inf_comm]
  rw [inf_sup_self]
  nth_rw 2 [inf_comm]
  rw [h]
  rw [← sup_assoc]
  nth_rw 2 [inf_comm]
  rw [sup_inf_self]
  rw [inf_comm]

example (h : ∀ x y z : α, x ⊔ y ⊓ z = (x ⊔ y) ⊓ (x ⊔ z)) : a ⊓ (b ⊔ c) = a ⊓ b ⊔ a ⊓ c := by
  rw [h]
  nth_rw 2 [sup_comm]
  rw [sup_inf_self]
  nth_rw 2 [sup_comm]
  rw [h]
  rw [← inf_assoc]
  nth_rw 2 [sup_comm]
  rw [inf_sup_self]
  nth_rw 2 [sup_comm]

end

section
variable {R : Type*} [Ring R] [PartialOrder R] [IsStrictOrderedRing R]
variable (a b c : R)

#check (add_le_add_left : a ≤ b → ∀ c, c + a ≤ c + b)
#check (mul_pos : 0 < a → 0 < b → 0 < a * b)

#check (mul_nonneg : 0 ≤ a → 0 ≤ b → 0 ≤ a * b)

theorem aux1 (h : a ≤ b) : 0 ≤ b - a := by
  rw [← sub_self a]
  rw [sub_eq_add_neg, sub_eq_add_neg]
  apply add_le_add_right
  apply h

theorem aux2 (h: 0 ≤ b - a) : a ≤ b := by
  rw [← add_zero a, ← add_zero b]
  nth_rw 2 [← sub_self a]
  rw [sub_eq_add_neg]
  rw [← add_assoc, add_comm b a, add_assoc]
  rw [← sub_eq_add_neg]
  apply add_le_add_left
  apply h

example (h : a ≤ b) (h' : 0 ≤ c) : a * c ≤ b * c := by
  have h₁ : 0 ≤ (b - a) * c := by
    apply mul_nonneg
    · apply aux1
      apply h
    · apply h'
  rw [sub_mul] at h₁
  apply aux2 at h₁
  exact h₁

end

section
variable {X : Type*} [MetricSpace X]
variable (x y z : X)

#check (dist_self x : dist x x = 0)
#check (dist_comm x y : dist x y = dist y x)
#check (dist_triangle x y z : dist x z ≤ dist x y + dist y z)

example (x y : X) : 0 ≤ dist x y := by
  have h : dist x x ≤ dist x y + dist y x := dist_triangle x y x
  rw [dist_comm y x, ← mul_two] at h
  rw [dist_self] at h
  linarith

end
