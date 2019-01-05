libc_src_dirs       = $(SOURCE_DIR)/src/*/
libc_src_dirs      += $(SOURCE_DIR)/crt/
libc_src_dirs      += $(SOURCE_DIR)/ldso/

ifeq ($(PORT_DIR),$(PROJECT_DIR))
libc_src_dirs      += $(PROJECT_DIR)/src/*/
libc_src_dirs      += $(PROJECT_DIR)/crt/
libc_src_dirs      += $(PROJECT_DIR)/ldso/
endif

libc_src_files      = $(wildcard $(addsuffix *.c,$(libc_src_dirs)))
libc_src_sorted     = $(sort $(libc_src_files))

libc_src_merged     = $(subst $(SOURCE_DIR)/,./, \
		      $(subst $(PROJECT_DIR)/,./, \
		        $(libc_src_sorted)))

libc_arch_dirs      = $(wildcard $(addsuffix $(ARCH)/, $(libc_src_dirs)))

libc_arch_files_c   = $(wildcard $(addsuffix *.c,$(libc_arch_dirs)))
libc_arch_files_s   = $(wildcard $(addsuffix *.s,$(libc_arch_dirs)))
libc_arch_files_S   = $(wildcard $(addsuffix *.S,$(libc_arch_dirs)))

libc_arch_files     = $(subst $(SOURCE_DIR)/,./, \
		      $(subst $(PROJECT_DIR)/,./, \
		        $(libc_arch_files_c)       \
		        $(libc_arch_files_s)        \
		        $(libc_arch_files_S)))

libc_arch_substs_c  = $(subst /$(ARCH)/,/,$(libc_arch_files_c))
libc_arch_substs_s  = $(subst /$(ARCH)/,/,$(libc_arch_files_s))
libc_arch_substs_S  = $(subst /$(ARCH)/,/,$(libc_arch_files_S))

libc_arch_substs    = $(subst $(SOURCE_DIR)/,./,   \
		      $(subst $(PROJECT_DIR)/,./,   \
		        $(libc_arch_substs_c)        \
		        $(libc_arch_substs_s:%.s=%.c) \
		        $(libc_arch_substs_S:%.S=%.c)))

libc_pure_files     = $(filter-out $(libc_arch_substs), $(libc_src_merged))
libc_all_files      = $(libc_pure_files) $(libc_arch_files)

libc_crt_files_c    = $(filter ./crt/%.c,  $(libc_all_files))
libc_crt_files_s    = $(filter ./crt/%.s,  $(libc_all_files))
libc_crt_files_S    = $(filter ./crt/%.S,  $(libc_all_files))
libc_crt_files      = $(filter ./crt/%,  $(libc_all_files))

libc_ldso_files     = $(filter ./ldso/%,  $(libc_all_files))
libc_ldso_files    += $(filter ./src/ldso/%,  $(libc_all_files))

libc_ldso_files_c   = $(filter %.c, $(libc_ldso_files))
libc_ldso_files_s   = $(filter %.s, $(libc_ldso_files))
libc_ldso_files_S   = $(filter %.S, $(libc_ldso_files))

libc_excl_files     = $(libc_crt_files) $(libc_ldso_files)
libc_core_files     = $(filter-out $(libc_excl_files), $(libc_all_files))

libc_core_files_c   = $(filter %.c, $(libc_core_files))
libc_core_files_s   = $(filter %.s, $(libc_core_files))
libc_core_files_S   = $(filter %.S, $(libc_core_files))

libc_tree_dirs      = $(subst $(SOURCE_DIR)/,./,             \
		      $(subst $(PORT_DIR)/,./,                \
		        $(wildcard $(SOURCE_DIR)/src/*/)       \
		        $(wildcard $(PORT_DIR)/src/*/)          \
		        $(wildcard $(SOURCE_DIR)/src/*/$(ARCH)/) \
		        $(wildcard $(PORT_DIR)/src/*/$(ARCH)/)))

libc_tree_dirs     += ./crt/  ./crt/$(ARCH)/
libc_tree_dirs     += ./ldso/ ./ldso/$(ARCH)/
