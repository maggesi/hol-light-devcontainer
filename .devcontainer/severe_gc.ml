let original_gc_control = Gc.get();;

let severe_gc_control =
 {original_gc_control with
  Gc.space_overhead = 60;
  Gc.major_heap_increment = 10;
  Gc.max_overhead = 400};;

let set_servere_gc_control() =
  Gc.set severe_gc_control;;

let unset_servere_gc_control() =
  Gc.set original_gc_control;;

set_servere_gc_control();;

Gc.compact();;
