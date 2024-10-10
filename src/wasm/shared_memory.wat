(module
  ;; Import shared memory from the host. Allocate 1 page, with 1 page max. Shared between all instances.
  (import "env" "memory" (memory $0 1 1 shared))

  ;; Define a global variable to store a value. Make it mutable.
  (global $shared_value (mut i32) (i32.const 69))

  (func $init
    (i32.store (i32.const 0) (global.get $shared_value))
  )
  
  ;; Start function that initializes the shared memory with the global value at address 0.
  (start $init)
)
