	.global __vm_lock_impl
	.def	__vm_lock_impl; .scl 2; .type 32; .endef
__vm_lock_impl:
	jmp	__vm_lock


	.global __vm_unlock_impl
	.def	__vm_unlock_impl; .scl 2; .type 32; .endef
__vm_unlock_impl:
	jmp	__vm_unlock
