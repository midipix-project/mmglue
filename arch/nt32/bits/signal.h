#if defined(_POSIX_SOURCE) || defined(_POSIX_C_SOURCE) \
 || defined(_XOPEN_SOURCE) || defined(_GNU_SOURCE) || defined(_BSD_SOURCE)

#if defined(_XOPEN_SOURCE) || defined(_GNU_SOURCE) || defined(_BSD_SOURCE)
#define MINSIGSTKSZ	4096
#define SIGSTKSZ	8192
#endif

typedef struct {
	unsigned long	uc_ctrl_word;		/* 0x000 */
	unsigned long	uc_status_word;		/* 0x004 */
	unsigned long	uc_tag_word;		/* 0x008 */
	unsigned long	uc_error_offset;	/* 0x00c */
	unsigned long	uc_error_selector;	/* 0x010 */
	unsigned long	uc_data_offset;		/* 0x014 */
	unsigned long	uc_data_selector;	/* 0x018 */
	unsigned char 	uc_reg_area[80];	/* 0x01c */
	unsigned long	uc_cr0_npx_state;	/* 0x06c */
} uc_xsave_fmt_t;

typedef struct {
	unsigned long	uc_context_flags;	/* 0x000 */
	unsigned long	uc_dr0;			/* 0x004 */
	unsigned long	uc_dr1;			/* 0x008 */
	unsigned long	uc_dr2;			/* 0x00c */
	unsigned long	uc_dr3;			/* 0x010 */
	unsigned long	uc_dr6;			/* 0x014 */
	unsigned long	uc_dr7;			/* 0x018 */

	uc_xsave_fmt_t	uc_float_save;		/* 0x01c */

	unsigned long	uc_seg_gs; 		/* 0x08c */
	unsigned long	uc_seg_fs; 		/* 0x090 */
	unsigned long	uc_seg_es;		/* 0x094 */
	unsigned long	uc_seg_ds;		/* 0x098 */
	unsigned long	uc_edi;			/* 0x09c */
	unsigned long	uc_esi;			/* 0x0a0 */
	unsigned long	uc_ebx;			/* 0x0a4 */
	unsigned long	uc_edx;			/* 0x0a8 */
	unsigned long	uc_ecx;			/* 0x0ac */
	unsigned long	uc_eax;			/* 0x0b0 */
	unsigned long	uc_ebp;			/* 0x0b4 */
	unsigned long	uc_eip;			/* 0x0b8 */
	unsigned long	uc_seg_cs; 		/* 0x0bc */
	unsigned long	uc_eflags;		/* 0x0c0 */
	unsigned long	uc_esp;			/* 0x0c4 */
	unsigned long	uc_seg_ss;		/* 0x0c8 */
	unsigned char	uc_extended_regs[512];	/* 0x0cc */
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
