#ifndef _PSXSEH_H_
#define _PSXSEH_H_


enum __unwind_reason_code;

struct _nt_exception_record;
struct _nt_dispatcher_context;

struct __unwind_exception;
struct __unwind_context;




typedef void __thread_context;

typedef enum __unwind_reason_code(*__unwind_personality_routine)(
	int, int, uintptr_t,
	struct __unwind_exception *,
	struct __unwind_context *);

typedef void (*__unwind_exception_cleanup_routine)(
	enum __unwind_reason_code,
	struct __unwind_exception *);



struct __seh_vtbl {
	int    (*seh_exception_filter)(
		struct _nt_exception_record *,
		void *,
		__thread_context *,
		struct _nt_dispatcher_context *,
		__unwind_personality_routine);

	int    (*seh_exception_handler)(
		struct _nt_exception_record *,
		uintptr_t,
		__thread_context *,
		struct _nt_dispatcher_context *);

	int    (*seh_unwind_raise_exception)(
		struct __unwind_exception *);

	void   (*seh_unwind_delete_exception)(
		struct __unwind_exception *);

	void   (*seh_unwind_resume)(
		struct __unwind_exception *);

	int    (*seh_unwind_resume_or_rethrow)(
		struct __unwind_exception *);

	int    (*seh_unwind_force)(
		struct __unwind_exception *,
		int (*)(
			int, int, uintptr_t,
			struct __unwind_exception *,
			struct __unwind_context *,
			void *),
		void *);

	void * (*seh_unwind_get_language_specific_data)(
		struct __unwind_context *);

	int    (*seh_unwind_backtrace)(
		enum __unwind_reason_code (*)(
			struct __unwind_context *,
			void *),
		void *);

	int    (*seh_unwind_calltrace)();


	uintptr_t (*seh_unwind_get_ip)(const struct __unwind_context *);
	void      (*seh_unwind_set_ip)(struct __unwind_context *, uintptr_t);

	uintptr_t (*seh_unwind_get_gr)(const struct __unwind_context *, int);
	void      (*seh_unwind_set_gr)(struct __unwind_context *, int, uintptr_t);

	uintptr_t (*seh_unwind_get_data_rel_base)(const struct __unwind_context *);
	uintptr_t (*seh_unwind_get_text_rel_base)(const struct __unwind_context *);

	uintptr_t (*seh_unwind_get_cfa)(const struct __unwind_context *);
	uintptr_t (*seh_unwind_get_ip_info)(const struct __unwind_context *, int *);

	uintptr_t (*seh_unwind_get_region_start)(const struct __unwind_context *);
	void *    (*seh_unwind_find_enclosing_function)(const void *);

	int       (*__seh_vtbl_reserved[12]);
};

#endif
