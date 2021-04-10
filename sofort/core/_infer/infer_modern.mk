# infer_modern.mk: modern make target- and inference rules.
# this file is covered by COPYING.SOFORT.

src/%.ao: 	$(SOURCE_DIR)/src/%.c
		$(CC) -c -o $@ $< $(CFLAGS_APP)

src/%.lo: 	$(SOURCE_DIR)/src/%.c
		$(CC) -c -o $@ $< $(CFLAGS_SHARED)

src/%.o: 	$(SOURCE_DIR)/src/%.c
		$(CC) -c -o $@ $< $(CFLAGS_STATIC)

$(SHARED_LIB):
		$(SHARED_LIB_CMD) $@ $^ $(SHARED_LIB_LDFLAGS) $(LDFLAGS_IMPLIB)

lib/%$(OS_ARCHIVE_EXT):
		mkdir -p lib
		rm -f $@
		$(AR) rcs $@ $^
