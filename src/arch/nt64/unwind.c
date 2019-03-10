#include <stdint.h>
#include <signal.h>
#include <sys/unwind.h>
#include "psxseh.h"

extern const struct __seh_vtbl * __seh_vtbl;


int __unwind_exception_filter(
	struct _nt_exception_record * erec,
	void * fctx,
	mcontext_t * tctx,
	struct _nt_dispatcher_context * dctx,
	__unwind_personality_routine uw_routine)
{
	return __seh_vtbl->seh_exception_filter(
		erec,fctx,tctx,dctx,uw_routine);
}


int __unwind_exception_handler(
	struct _nt_exception_record * erec,
	uintptr_t fbase,
	mcontext_t * tctx,
	struct _nt_dispatcher_context * dctx)
{
	return __seh_vtbl->seh_exception_handler(
		erec,fbase,tctx,dctx);
}


int __unwind_raise_exception(struct __unwind_exception * e)
{
	return __seh_vtbl->seh_unwind_raise_exception(e);
}


void __unwind_delete_exception(struct __unwind_exception * e)
{
	return __seh_vtbl->seh_unwind_delete_exception(e);
}


void __unwind_resume(struct __unwind_exception * e)
{
	return __seh_vtbl->seh_unwind_resume(e);
}


int __unwind_resume_or_rethrow(struct __unwind_exception * e)
{
	return __seh_vtbl->seh_unwind_resume_or_rethrow(e);
}


int __unwind_force(
	struct __unwind_exception * e,
	int (*stop_fn)(
		int, int, uintptr_t,
		struct __unwind_exception *,
		struct __unwind_context *,
		void *),
	void * ctx)
{
	return __seh_vtbl->seh_unwind_force(e,stop_fn,ctx);
}


void * __unwind_get_language_specific_data(struct __unwind_context * uwctx)
{
	return __seh_vtbl->seh_unwind_get_language_specific_data(uwctx);
}


int __unwind_backtrace(
	enum __unwind_reason_code (*trace_fn)(
		struct __unwind_context *,
		void *),
	void * ctx)
{
	return __seh_vtbl->seh_unwind_backtrace(trace_fn,ctx);
}


int __unwind_calltrace()
{
	return __seh_vtbl->seh_unwind_calltrace();
}


uintptr_t __unwind_get_ip(const struct __unwind_context * uwctx)
{
	return __seh_vtbl->seh_unwind_get_ip(uwctx);
}


void __unwind_set_ip(struct __unwind_context * uwctx, uintptr_t ip)
{
	return __seh_vtbl->seh_unwind_set_ip(uwctx,ip);
}


uintptr_t __unwind_get_gr(const struct __unwind_context * uwctx, int idx)
{
	return __seh_vtbl->seh_unwind_get_gr(uwctx,idx);
}


void __unwind_set_gr(struct __unwind_context * uwctx, int idx, uintptr_t rval)
{
	return __seh_vtbl->seh_unwind_set_gr(uwctx,idx,rval);
}


uintptr_t __unwind_get_data_rel_base(const struct __unwind_context * uwctx)
{
	return __seh_vtbl->seh_unwind_get_data_rel_base(uwctx);
}


uintptr_t __unwind_get_text_rel_base(const struct __unwind_context * uwctx)
{
	return __seh_vtbl->seh_unwind_get_text_rel_base(uwctx);
}


uintptr_t __unwind_get_cfa(const struct __unwind_context * uwctx)
{
	return __seh_vtbl->seh_unwind_get_cfa(uwctx);
}


uintptr_t __unwind_get_ip_info(const struct __unwind_context * uwctx, int * pinfo)
{
	return __seh_vtbl->seh_unwind_get_ip_info(uwctx,pinfo);
}


uintptr_t __unwind_get_region_start(const struct __unwind_context * uwctx)
{
	return __seh_vtbl->seh_unwind_get_region_start(uwctx);
}


void * __unwind_find_enclosing_function(const void * addr)
{
	return __seh_vtbl->seh_unwind_find_enclosing_function(addr);
}
