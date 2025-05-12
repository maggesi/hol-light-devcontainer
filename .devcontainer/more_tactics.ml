(* ========================================================================= *)
(* Useful rules, conversions and tactics.                                    *)
(* ========================================================================= *)

(* Riduce espressioni reali razionali nella conclusione del goal.
   Vedi REAL_RAT_REDUCE_CONV. *)
let REAL_RAT_REDUCE_TAC : tactic =
  CONV_TAC REAL_RAT_REDUCE_CONV;;

(* Applica la procedura di decisione per i domini di integrità nei reali
   alla conclusione del goal.  Vedi REAL_RING. *)
let REAL_RING_TAC : tactic =
  CONV_TAC REAL_RING;;

(* Come REAL_RING_TAC ma usa le assunzioni del goal. *)
let ASM_REAL_RING_TAC =
  REPEAT(FIRST_X_ASSUM(MP_TAC o check (not o is_forall o concl))) THEN
  REAL_RING_TAC;;

(* Applica la procedura di decisione per i campi nei reali
   alla conclusione del goal.  Vedi REAL_FIELD. *)
let REAL_FIELD_TAC : tactic =
  CONV_TAC REAL_FIELD;;

(* Come REAL_FIELD_TAC ma usa le assunzioni del goal. *)
let ASM_REAL_FIELD_TAC =
  REPEAT(FIRST_X_ASSUM(MP_TAC o check (not o is_forall o concl))) THEN
  REAL_FIELD_TAC;;

(* Regole di riscrittura per la speplificazione delle formule booleane. *)
let boolean_rewrites =
  (ref o map (fun tm -> prove(tm,REWRITE_TAC[])))
  [`(if T then t1 else t2) = t1:A`; `(if F then t1 else t2) = t2:A`;
   `~ ~t <=> t`; `x = x <=> T`; `(T <=> t) <=> t`; `(t <=> T) <=> t`;
   `(F <=> t) <=> ~t`; `(t <=> F) <=> ~t`; `~T <=> F`;
   `~F <=> T`; `T /\ t <=> t`; `t /\ T <=> t`; `F /\ t <=> F`;
   `t /\ F <=> F`; `t /\ t <=> t`; `T \/ t <=> T`; `t \/ T <=> T`;
   `F \/ t <=> t`; `t \/ F <=> t`; `t \/ t <=> t`; `T ==> t <=> t`;
   `t ==> T <=> T`; `F ==> t <=> T`; `t ==> t <=> T`; `t ==> F <=> ~t`;
   `(!x:A. t) <=> t`; `(?x:A. t) <=> t`];;

(* Conversione per la semplificazione delle formule booleane. *)
let BOOL_REDUCE_CONV : conv =
  GEN_REWRITE_CONV TOP_DEPTH_CONV (!boolean_rewrites);;

(* Conversione per la semplificazione polinomiale in profondità.
   Vedi anche REAL_POLY_CONV. *)
let DEPTH_REAL_POLY_CONV : conv =
  ONCE_DEPTH_CONV (CHANGED_CONV REAL_POLY_CONV) THENC
  BOOL_REDUCE_CONV;;

(* Tattica per la semplificazione polinomiale in profondità.
   Vedi anche REAL_POLY_CONV.  *)
let DEPTH_REAL_POLY_TAC : tactic =
  CONV_TAC DEPTH_REAL_POLY_CONV;;

(* Regola di semplificazione polinomiale in profondità.
   Vedi anche REAL_POLY_CONV.  *)
let DEPTH_REAL_POLY_RULE : thm->thm =
  CONV_RULE DEPTH_REAL_POLY_CONV;;

