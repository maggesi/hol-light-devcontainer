#use "make.ml";;

loadt "update_database.ml";;

let gc_control = Gc.get();;

Gc.set {gc_control with
  Gc.space_overhead = 60;
  Gc.major_heap_increment = 10;
  Gc.max_overhead = 400};;

Gc.compact();;
