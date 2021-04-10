# infer_posix.mk: posix make target- and inference rules.
# this file is covered by COPYING.SOFORT.

.c.ao:
	$(CC) -c -o $@ $< $(CFLAGS_APP)

.c.lo:
	$(CC) -c -o $@ $< $(CFLAGS_SHARED)

.c.o:
	$(CC) -c -o $@ $< $(CFLAGS_STATIC)

$(SHARED_LIB):
		$(SHARED_LIB_CMD) $@ $(SHARED_OBJS) $(SHARED_LIB_LDFLAGS) $(LDFLAGS_IMPLIB)

$(STATIC_LIB):
		mkdir -p lib
		rm -f $@
		$(AR) rcs $@ $(STATIC_OBJS)

srcs.tag:	tree.tag

srcs.tag:
	$(PROJECT_DIR)/sofort/tools/srctree.sh \
		--srctree=$(SOURCE_DIR) --      \
		$(COMMON_SRCS) $(APP_SRCS)
	touch $@
