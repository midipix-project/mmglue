	.globl	__vm_lock_impl	 /* symbol excluded from libc.so */
__vm_lock_impl:
	jmp	__vm_lock


	.globl	__vm_unlock_impl /* symbol excluded from libc.so */
__vm_unlock_impl:
	jmp	__vm_unlock
