(module
  ;; Import necessary functions from wasi_snapshot_preview1
  (import "wasi_snapshot_preview1" "clock_time_get" (func $clock_time_get (param i32 i64) (result i64)))
  (import "wasi_snapshot_preview1" "fd_write" (func $fd_write (param i32 i32 i32 i32) (result i32)))

  ;; Memory allocation for storing the result
  (memory $mem 1 1)
  
  ;; Function to get current time
  (func $get_current_time (local $time_ptr i32) (local $len i32)
    ;; Allocate memory for the result
    local.set $time_ptr (i32.const 0)

    ;; Call clock_time_get with CLOCK_REALTIME and our allocated memory
    call $clock_time_get (i32.const 0) (local.get $time_ptr)

    ;; Convert nanoseconds to seconds
    local.set $len (load i64 (local.get $time_ptr))
    local.set $len (i64.div_s (local.get $len) (i64.const 1000000000))

    ;; Store the result as a string
    store i32 (local.get $len) (i32.const 0)
    store i32 (i32.const 10) (i32.add (i32.const 0) (i32.const 4))

    ;; Write the result to stdout
    call $fd_write (i32.const 1) (i32.const 0) (i32.const 5) (local.get $len)
  )

  ;; Export the function so it can be called from outside
  (export "run" (func $get_current_time))
)
