#if defined(_POSIX_SOURCE) || defined(_POSIX_C_SOURCE) \
 || defined(_XOPEN_SOURCE) || defined(_GNU_SOURCE) || defined(_BSD_SOURCE)

#if defined(_XOPEN_SOURCE) || defined(_GNU_SOURCE) || defined(_BSD_SOURCE)
#define MINSIGSTKSZ	4096
#define SIGSTKSZ	8192
#endif

typedef struct {
	unsigned long	uc_low;
	signed long	uc_high;
} uc_m128a_t;

typedef struct {
	unsigned short		uc_control_word;		/* 0x000 */
	unsigned short		uc_status_word;			/* 0x002 */
	unsigned char		uc_tag_word;			/* 0x004 */
	unsigned char		uc_reserved1;			/* 0x005 */
	unsigned short		uc_error_opcode;		/* 0x006 */
	unsigned int		uc_error_offset;		/* 0x008 */
	unsigned short		uc_error_selector;		/* 0x00c */
	unsigned short		uc_reserved2;			/* 0x00e */
	unsigned int		uc_data_offset;			/* 0x010 */
	unsigned short		uc_data_selector;		/* 0x014 */
	unsigned short		uc_reserved3;			/* 0x016 */
	unsigned int		uc_mx_csr;			/* 0x018 */
	unsigned int		uc_mx_csr_mask;			/* 0x01c */
	uc_m128a_t		uc_float_registers[8];		/* 0x020 */
	uc_m128a_t		uc_xmm_registers[16];		/* 0x0a0 */
	unsigned char		uc_reserved4[96];		/* 0x1a0 */
} uc_xsave_fmt_t;

typedef struct {
	unsigned long		uc_p1_home;			/* 0x000 */
	unsigned long		uc_p2_home;			/* 0x008 */
	unsigned long		uc_p3_home;			/* 0x010 */
	unsigned long		uc_p4_home;			/* 0x018 */
	unsigned long		uc_p5_home;			/* 0x020 */
	unsigned long		uc_p6_home;			/* 0x028 */
	unsigned int		uc_context_flags;		/* 0x030 */
	unsigned int		uc_mx_csr;			/* 0x034 */
	unsigned short		uc_seg_cs;			/* 0x038 */
	unsigned short		uc_seg_ds;			/* 0x03a */
	unsigned short		uc_seg_es;			/* 0x03c */
	unsigned short		uc_seg_fs;			/* 0x03e */
	unsigned short		uc_seg_gs;			/* 0x040 */
	unsigned short		uc_seg_ss;			/* 0x042 */
	unsigned int		uc_eflags;			/* 0x044 */
	unsigned long		uc_dr0;				/* 0x048 */
	unsigned long		uc_dr1;				/* 0x050 */
	unsigned long		uc_dr2;				/* 0x058 */
	unsigned long		uc_dr3;				/* 0x060 */
	unsigned long		uc_dr6;				/* 0x068 */
	unsigned long		uc_dr7;				/* 0x070 */
	unsigned long		uc_rax;				/* 0x078 */
	unsigned long		uc_rcx;				/* 0x080 */
	unsigned long		uc_rdx;				/* 0x088 */
	unsigned long		uc_rbx;				/* 0x090 */
	unsigned long		uc_rsp;				/* 0x098 */
	unsigned long		uc_rbp;				/* 0x0a0 */
	unsigned long		uc_rsi;				/* 0x0a8 */
	unsigned long		uc_rdi;				/* 0x0b0 */
	unsigned long		uc_r8;				/* 0x0b8 */
	unsigned long		uc_r9;				/* 0x0c0 */
	unsigned long		uc_r10;				/* 0x0c8 */
	unsigned long		uc_r11;				/* 0x0d0 */
	unsigned long		uc_r12;				/* 0x0d8 */
	unsigned long		uc_r13;				/* 0x0e0 */
	unsigned long		uc_r14;				/* 0x0e8 */
	unsigned long		uc_r15;				/* 0x0f0 */
	unsigned long		uc_rip;				/* 0x0f8 */

	union {
		uc_xsave_fmt_t		uc_flt_save;		/* 0x100 */

		struct {
			uc_m128a_t	uc_header[2];		/* 0x100 */
			uc_m128a_t	uc_legacy[8];		/* 0x120 */
		} uc_hdr;
	} uc_flt;

	uc_m128a_t		uc_xmm0;			/* 0x1a0 */
	uc_m128a_t		uc_xmm1;			/* 0x1b0 */
	uc_m128a_t		uc_xmm2;			/* 0x1c0 */
	uc_m128a_t		uc_xmm3;			/* 0x1d0 */
	uc_m128a_t		uc_xmm4;			/* 0x1e0 */
	uc_m128a_t		uc_xmm5;			/* 0x1f0 */
	uc_m128a_t		uc_xmm6;			/* 0x200 */
	uc_m128a_t		uc_xmm7;			/* 0x210 */
	uc_m128a_t		uc_xmm8;			/* 0x220 */
	uc_m128a_t		uc_xmm9;			/* 0x230 */
	uc_m128a_t		uc_xmm10;			/* 0x240 */
	uc_m128a_t		uc_xmm11;			/* 0x250 */
	uc_m128a_t		uc_xmm12;			/* 0x260 */
	uc_m128a_t		uc_xmm13;			/* 0x270 */
	uc_m128a_t		uc_xmm14;			/* 0x280 */
	uc_m128a_t		uc_xmm15;			/* 0x290 */
	uc_m128a_t		uc_vector_register[26];		/* 0x300 */
	unsigned long		uc_vector_control;		/* 0x4a0 */
	unsigned long		uc_debug_control;		/* 0x4a8 */
	unsigned long		uc_last_branch_to_rip;		/* 0x4b0 */
	unsigned long		uc_last_branch_from_rip;	/* 0x4b8 */
	unsigned long		uc_last_exception_to_rip;	/* 0x4c0 */
	unsigned long		uc_last_exception_from_rip;	/* 0x4c8 */
	unsigned long		uc_reserved[6];			/* 0x4d0 */
} mcontext_t;

struct sigaltstack {
	void *	ss_sp;
	int	ss_flags;
	size_t	ss_size;
};

typedef struct __ucontext {
	unsigned int		uc_csize;
	unsigned int		uc_msize;
	unsigned int		uc_pad[2];
	unsigned long		uc_flags;
	unsigned long		uc_opaquef[3];
	unsigned int		uc_opaquec[8];
	unsigned long		uc_reserved[32];
	unsigned long		uc_align[2];
	stack_t			uc_stack;
	struct __ucontext *	uc_link;
	sigset_t		uc_sigmask;
	mcontext_t		uc_mcontext;
} ucontext_t;

#define SA_NOCLDSTOP  1
#define SA_NOCLDWAIT  2
#define SA_SIGINFO    4
#define SA_ONSTACK    0x08000000
#define SA_RESTART    0x10000000
#define SA_NODEFER    0x40000000
#define SA_RESETHAND  0x80000000
#define SA_RESTORER   0x04000000

#endif

#define SIGHUP    1
#define SIGINT    2
#define SIGQUIT   3
#define SIGILL    4
#define SIGTRAP   5
#define SIGABRT   6
#define SIGIOT    SIGABRT
#define SIGBUS    7
#define SIGFPE    8
#define SIGKILL   9
#define SIGUSR1   10
#define SIGSEGV   11
#define SIGUSR2   12
#define SIGPIPE   13
#define SIGALRM   14
#define SIGTERM   15
#define SIGSTKFLT 16
#define SIGCHLD   17
#define SIGCONT   18
#define SIGSTOP   19
#define SIGTSTP   20
#define SIGTTIN   21
#define SIGTTOU   22
#define SIGURG    23
#define SIGXCPU   24
#define SIGXFSZ   25
#define SIGVTALRM 26
#define SIGPROF   27
#define SIGWINCH  28
#define SIGIO     29
#define SIGPOLL   29
#define SIGPWR    30
#define SIGSYS    31
#define SIGUNUSED SIGSYS

#define _NSIG 65

