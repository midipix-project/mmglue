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

libc_arch_dirs      = $(sort $(wildcard $(addsuffix $(ARCH)/, $(libc_src_dirs))))

libc_arch_files_c   = $(subst $(PORT_DIR)/,./,$(wildcard $(addsuffix *.c,$(libc_arch_dirs))))
libc_arch_files_s   = $(subst $(PORT_DIR)/,./,$(wildcard $(addsuffix *.s,$(libc_arch_dirs))))
libc_arch_files_S   = $(subst $(PORT_DIR)/,./,$(wildcard $(addsuffix *.S,$(libc_arch_dirs))))

libc_arch_files     = $(libc_arch_files_c) \
		      $(libc_arch_files_s)  \
		      $(libc_arch_files_S)

libc_arch_substs_c  = $(subst /$(ARCH)/,/,$(libc_arch_files_c))
libc_arch_substs_s  = $(subst /$(ARCH)/,/,$(libc_arch_files_s))
libc_arch_substs_S  = $(subst /$(ARCH)/,/,$(libc_arch_files_S))

libc_arch_substs    = $(libc_arch_substs_c)        \
		      $(libc_arch_substs_s:%.s=%.c) \
		      $(libc_arch_substs_S:%.S=%.c)

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


# core objects
STATIC_OBJS        += $(libc_core_files_c:%.c=%.o)
STATIC_OBJS        += $(libc_core_files_s:%.s=%.o)
STATIC_OBJS        += $(libc_core_files_S:%.S=%.o)

SHARED_OBJS        += $(libc_core_files_c:%.c=%.lo)
SHARED_OBJS        += $(libc_core_files_s:%.s=%.lo)
SHARED_OBJS        += $(libc_core_files_S:%.S=%.lo)

$(STATIC_OBJS):       headers.tag host.tag tree.tag
$(SHARED_OBJS):       headers.tag host.tag tree.tag

$(SHARED_OBJS):       CFLAGS_SHARED += -DSHARED=

src/%.o:$(PORT_DIR)/src/%.c
	$(CC) -c -o $@ $< $(CFLAGS_STATIC)

src/%.o:$(PORT_DIR)/src/%.s
	$(AS) -o $@ $<

src/%.o:$(PORT_DIR)/src/%.S
	$(CC) -c -o $@ $< $(CFLAGS_STATIC)

src/%.lo:$(PORT_DIR)/src/%.c
	$(CC) -c -o $@ $< $(CFLAGS_SHARED)

src/%.lo:$(PORT_DIR)/src/%.s
	$(AS) -o $@ $<

src/%.lo:$(PORT_DIR)/src/%.S
	$(CC) -c -o $@ $< $(CFLAGS_SHARED)


# crt objects
CRT_OBJS           += $(libc_crt_files_c:%.c=%.o)
CRT_OBJS           += $(libc_crt_files_s:%.s=%.o)
CRT_OBJS           += $(libc_crt_files_S:%.S=%.o)

$(CRT_OBJS):          headers.tag host.tag tree.tag
$(CRT_OBJS):          CFLAGS_CONFIG += -DCRT

./crt/Scrt1.o:        CFLAGS_CONFIG += -fPIC
./crt/rcrt1.o:        CFLAGS_CONFIG += -fPIC

crt/%.o:$(PORT_DIR)/crt/%.c
	$(CC) -c -o $@ $< $(CFLAGS_STATIC)

crt/%.o:$(PORT_DIR)/crt/%.s
	$(AS) -o $@ $<

crt/%.o:$(PORT_DIR)/crt/%.S
	$(CC) -c -o $@ $< $(CFLAGS_STATIC)

crt/%.o:$(SOURCE_DIR)/crt/%.c
	$(CC) -c -o $@ $< $(CFLAGS_STATIC)

crt-objs:  $(CRT_OBJS)
shared-lib:$(CRT_OBJS)
static-lib:$(CRT_OBJS)

clean-crt-objs:
	rm -f $(CRT_OBJS)

clean:	clean-crt-objs

.PHONY:	crt-objs clean-crt-objs


# ldso objects
LDSO_OBJS          += $(libc_ldso_files_c:%.c=%.lo)
LDSO_OBJS          += $(libc_ldso_files_s:%.s=%.lo)
LDSO_OBJS          += $(libc_ldso_files_S:%.S=%.lo)

$(LDSO_OBJS):         headers.tag host.tag tree.tag

$(LDSO_OBJS):         CFLAGS_SHARED += -DSHARED=

ldso/%.lo:$(PORT_DIR)/ldso/%.c
	$(CC) -c -o $@ $< $(CFLAGS_SHARED)

ldso/%.lo:$(PORT_DIR)/ldso/%.s
	$(AS) -o $@ $<

ldso/%.lo:$(PORT_DIR)/ldso/%.S
	$(CC) -c -o $@ $< $(CFLAGS_SHARED)

ldso/%.lo:$(SOURCE_DIR)/ldso/%.c
	$(CC) -c -o $@ $< $(CFLAGS_SHARED)

ldso-objs:$(LDSO_OBJS)

clean-ldso-objs:
	rm -f $(LDSO_OBJS)

clean:	clean-ldso-objs

.PHONY:	ldso-objs clean-ldso-objs
