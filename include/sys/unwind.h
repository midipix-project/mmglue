#ifndef _SYS_UNWIND_H
#define _SYS_UNWIND_H

#include <stdint.h>
#include <signal.h>

#ifdef __cplusplus
extern "C" {
#endif

enum __unwind_reason_code {
	__URC_NO_REASON,
	__URC_FOREIGN_EXCEPTION,
	__URC_FATAL_PHASE2,
	__URC_FATAL_PHASE1,
	__URC_NORMAL_STOP,
	__URC_END_OF_STACK,
	__URC_HANDLER_FOUND,
	__URC_INSTALL_CONTEXT,
	__URC_CONTINUE_UNWIND,
};


#define __UA_SEARCH_PHASE       0x01
#define __UA_CLEANUP_PHASE      0x02
#define __UA_HANDLER_FRAME      0x04
#define __UA_FORCE_UNWIND       0x08
#define __UA_END_OF_STACK       0x10




struct __exception_record;
struct __dispatcher_context;

struct __unwind_exception;
struct __unwind_context;




typedef enum __unwind_reason_code(*__unwind_personality_routine)(
	int, int, uintptr_t,
	struct __unwind_exception *,
	struct __unwind_context *);

typedef void (*__unwind_exception_cleanup_routine)(
	enum __unwind_reason_code,
	struct __unwind_exception *);



struct __unwind_exception {
	uintptr_t                               exception_class;
	__unwind_exception_cleanup_routine      exception_cleanup;
	uintptr_t                               __opaque[6];
};



int    __unwind_exception_filter(
	struct __exception_record *,
	void *,
	mcontext_t *,
	struct __dispatcher_context *,
	__unwind_personality_routine);

int    __unwind_exception_handler(
	struct __exception_record *,
	uintptr_t,
	mcontext_t *,
	struct __dispatcher_context *);

int    __unwind_raise_exception(
	struct __unwind_exception *);

void   __unwind_delete_exception(
	struct __unwind_exception *);

void   __unwind_resume(
	struct __unwind_exception *);

int    __unwind_resume_or_rethrow(
	struct __unwind_exception *);

int    __unwind_force(
	struct __unwind_exception *,
	int (*)(
		int, int, uintptr_t,
		struct __unwind_exception *,
		struct __unwind_context *,
		void *),
	void *);

void * __unwind_get_language_specific_data(
	struct __unwind_context *);

int    __unwind_backtrace(
	enum __unwind_reason_code (*)(
		struct __unwind_context *,
		void *),
	void *);

int    __unwind_calltrace();

uintptr_t __unwind_get_ip(const struct __unwind_context *);
void      __unwind_set_ip(struct __unwind_context *, uintptr_t);

uintptr_t __unwind_get_gr(const struct __unwind_context *, int);
void      __unwind_set_gr(struct __unwind_context *, int, uintptr_t);

uintptr_t __unwind_get_data_rel_base(const struct __unwind_context *);
uintptr_t __unwind_get_text_rel_base(const struct __unwind_context *);

uintptr_t __unwind_get_cfa(const struct __unwind_context *);
uintptr_t __unwind_get_ip_info(const struct __unwind_context *, int *);

uintptr_t __unwind_get_region_start(const struct __unwind_context *);
void *    __unwind_find_enclosing_function(const void *);

#ifdef __cplusplus
}
#endif

#endif
