	.globl	___vm_lock_impl	 /* symbol excluded from libc.so */
___vm_lock_impl:
	jmp	___vm_lock


	.globl	___vm_unlock_impl /* symbol excluded from libc.so */
___vm_unlock_impl:
	jmp	___vm_unlock
