tree.tag:
		mkdir -p src
		mkdir -p $(libc_tree_dirs)
		touch tree.tag

clean-tree:
		rmdir $(libc_tree_dirs) 2>/dev/null || true
		rmdir $(libc_tree_dirs) 2>/dev/null || true
		rmdir src               2>/dev/null || true
		rm -f tree.tag

clean:		clean-tree

.PHONY:		clean-tree
