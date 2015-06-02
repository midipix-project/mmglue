	.global ___vm_lock_impl
	.def	___vm_lock_impl; .scl 2; .type 32; .endef
___vm_lock_impl:
	jmp	___vm_lock


	.global ___vm_unlock_impl
	.def	___vm_unlock_impl; .scl 2; .type 32; .endef
___vm_unlock_impl:
	jmp	___vm_unlock
