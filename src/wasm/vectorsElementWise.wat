(module
    (memory (import "js" "mem") 1)

    (func (export "accumulate") (param $ptr i32) (param $len i32) (result f64)
        (local $sum f64)

        (f64.const 0.0)     ;; Initialize sum to 0
        (local.set $sum)

        (loop $loop         ;; Outer loop
            ;; Check if len > 0
            (local.get $len)
            (i32.eqz)
            (if (result i32)
                (then
                    (return (local.get $sum)) ;; If len == 0, return sum
                )
            )

            ;; Load element at ptr, add to sum
            (local.get $ptr)
            (f64.load offset=0 align=8)

            (local.get $sum)
            (f64.add)
            (local.set $sum)

            ;; Increment pointer and decrement len
            (local.set $ptr (i32.add (local.get $ptr) (i32.const 8)))
            (local.set $len (i32.sub (local.get $len) (i32.const 1)))

            ;; Check if we need to continue the loop
            (local.get $len) ;; Push len as the condition
            (br_if $loop)    ;; Break if len == 0
        )

        ;; Return the accumulated sum
        (local.get $sum)
    )

    (func (export "subtract") (param $ptr i32) (param $len i32) (result f64)
        (local $sum f64)

        (f64.const 0.0)     ;; Initialize sum to 0
        (local.set $sum)

        (loop $loop         ;; Outer loop
            ;; Check if len > 0
            (local.get $len)
            (i32.eqz)
            (if (result i32)
                (then
                    (return (local.get $sum)) ;; If len == 0, return sum
                )
            )

            ;; Load element at ptr, subtract from sum
            (local.get $ptr)
            (f64.load offset=0 align=8)

            (local.get $sum)
            (f64.sub)
            (local.set $sum)

            ;; Increment pointer and decrement len
            (local.set $ptr (i32.add (local.get $ptr) (i32.const 8)))
            (local.set $len (i32.sub (local.get $len) (i32.const 1)))

            ;; Check if we need to continue the loop
            (local.get $len) ;; Push len as the condition
            (br_if $loop)    ;; Break if len == 0
        )

        ;; Return the accumulated sum
        (local.get $sum)
    )
)
