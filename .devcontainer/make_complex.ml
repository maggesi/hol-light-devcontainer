(* ========================================================================= *)
(* Theory of multivariate calculus in Euclidean space.                       *)
(* ========================================================================= *)

needs "Library/card.ml";;               (* For countable set theorems.      *)
needs "Library/permutations.ml";;       (* For determinants                 *)
needs "Library/products.ml";;           (* For determinants and integrals   *)
needs "Library/floor.ml";;              (* Useful here and there            *)
needs "Multivariate/misc.ml";;          (* Background stuff                 *)
needs "Library/iter.ml";;               (* n-fold iteration of function     *)
needs "Library/grouptheory.ml";;        (* Groups, to support homology      *)
needs "Library/binomial.ml";;           (* For Leibniz deriv formula etc.   *)

(* ------------------------------------------------------------------------- *)
(* The main core theory.                                                     *)
(* ------------------------------------------------------------------------- *)

needs "Multivariate/metric.ml";;        (* General topology, metric spaces  *)
needs "Multivariate/homology.ml";;      (* Singular homology theory         *)
needs "Multivariate/vectors.ml";;       (* Basic vectors, linear algebra    *)
needs "Multivariate/determinants.ml";;  (* Determinant and trace            *)
needs "Multivariate/topology.ml";;      (* Topology of R^n and much else    *)
needs "Multivariate/convex.ml";;        (* Convex sets and functions        *)
needs "Multivariate/paths.ml";;         (* Paths, simple connectedness etc. *)
needs "Multivariate/polytope.ml";;      (* Faces, polytopes, polyhedra etc. *)
needs "Multivariate/degree.ml";;        (* Brouwer degree, retracts etc.    *)
needs "Multivariate/derivatives.ml";;   (* Derivatives                      *)
needs "Multivariate/clifford.ml";;      (* Geometric (Clifford) algebra     *)
needs "Multivariate/integration.ml";;   (* Integration, bounded variation   *)
needs "Multivariate/measure.ml";;       (* Lebesgue measure                 *)

(* ------------------------------------------------------------------------- *)
(* Complex numbers (as R^2), complex analysis and some more topology.        *)
(* ------------------------------------------------------------------------- *)

needs "Multivariate/complexes.ml";;       (* Complex numbers                *)
needs "Multivariate/canal.ml";;           (* Complex analysis               *)
needs "Multivariate/transcendentals.ml";; (* Real & complex transcendentals *)
needs "Multivariate/realanalysis.ml";;    (* Some analytical stuff on R     *)
needs "Multivariate/moretop.ml";;         (* Further topological results    *)
needs "Multivariate/cauchy.ml";;          (* Complex line integrals         *)

(* ========================================================================= *)
(* Quaternionic calculus.                                                    *)
(* ========================================================================= *)

prioritize_real ();;

needs "Quaternions/misc.hl";;        (* Miscellanea                         *)
needs "Quaternions/quaternion.hl";;  (* Basic definitions about quaternions *)
needs "Quaternions/qcalc.hl";;       (* Computing with literal quaternions  *)
needs "Quaternions/qnormalizer.hl";; (* Normalization of quat. polynomials  *)
needs "Quaternions/qanal.hl";;       (* Quaternionic analysis               *)
needs "Quaternions/qderivative.hl";; (* Differential of quat. functions     *)
needs "Quaternions/qisom.hl";;       (* Space isometries via quaternions    *)

(* ------------------------------------------------------------------------- *)
(* Update the database of theorems.                                          *)
(* ------------------------------------------------------------------------- *)

prioritize_quat ();;
prioritize_complex ();;
prioritize_vector ();;
prioritize_int ();;
prioritize_real ();;
prioritize_num ();;

needs "/workspaces/hol-light-devcontainer/.devcontainer/more.ml";;

loadt "update_database.ml";;

(* ------------------------------------------------------------------------- *)
(* Garbage collection.                                                       *)
(* ------------------------------------------------------------------------- *)

Gc.compact();;