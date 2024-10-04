(module
    (memory $mem 1)

    (func (export "accumulate") (param $ptr i32) (param $len i32) (result f64)
        (local $sum f64)

        ;; Initialize sum to zero
        (f64.const 0.0)
        (local.set $sum)

        ;; Loop through the array in chunks of 4 elements
        (loop $outer_loop
            ;; Check if we have at least 4 elements left
            (local.get $len)
            (i32.const 4)
            (i32.ge_u)
            (if
                (then
                    (block $inner_block
                        (loop $inner_loop
                            ;; Load and accumulate 4 elements at a time
                            (local.get $ptr)
                            (f64.load offset=0 align=8)
                            (local.get $sum)
                            (f64.add)
                            (local.set $sum)

                            ;; Advance the pointer by 8 bytes (size of f64)
                            (local.set $ptr (i32.add (local.get $ptr) (i32.const 8)))

                            ;; Continue the inner loop for all 4 elements
                            (br_if $inner_loop (i32.const 1))
                        )
                    )

                    ;; Update length to reflect the remaining elements
                    (local.set $len (i32.sub (local.get $len) (i32.const 4)))

                    ;; Continue outer loop if there are more elements
                    (br_if $outer_loop
                        (i32.gt_u (local.get $len) (i32.const 0))
                    )
                )
            )
        )

        ;; Handle remaining elements (less than 4)
        (loop $remaining_loop
            ;; Check if we've processed all elements
            (local.get $len)
            (i32.eqz)
            (if
                (then
                    (return (local.get $sum)) ;; Return accumulated sum if no elements left
                )
            )

            ;; Process remaining elements one by one
            (local.get $ptr)
            (f64.load offset=0 align=8)

            (local.get $sum)
            (f64.add)
            (local.set $sum)

            ;; Advance pointer by 8 bytes and decrease the length by 1
            (local.set $ptr (i32.add (local.get $ptr) (i32.const 8)))
            (local.set $len (i32.sub (local.get $len) (i32.const 1)))

            ;; Continue the loop while there are remaining elements
            (local.get $len)  ;; Push the remaining length as the condition
            (br_if $remaining_loop) ;; Break the loop if the length is zero
        )

        ;; Final return
        (return (local.get $sum))
    )
)
