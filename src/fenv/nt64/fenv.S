/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under GPLv2 and GPLv3; see COPYING.MMGLUE.                   */
/**************************************************************************/

	.file "fenv.S"

/* common exception bits */
#define FE_INVALID          (1 << 0)
#define FE_DENORM           (1 << 1)
#define FE_DIVBYZERO        (1 << 2)
#define FE_OVERFLOW         (1 << 3)
#define FE_UNDERFLOW        (1 << 4)
#define FE_INEXACT          (1 << 5)

#define FE_ALL_EXCEPT       (0x3F)

/* X87 FPU rounding control bits */
#define FPU_RC_TONEAREST    (0x0 << 10)
#define FPU_RC_DOWNWARD     (0x1 << 10)
#define FPU_RC_UPWARD       (0x2 << 10)
#define FPU_RC_TOWARDZERO   (0x3 << 10)
#define FPU_RC_MASK         FPU_RC_TOWARDZERO

/* X87 FPU control word */
#define FPU_CW_MASK         (0xFFFF)
#define FPU_CW_RC_MASK      (FPU_CW_MASK ^ FPU_RC_MASK)

/* MXCSR rounding control bits */
#define MXCSR_RC_TONEAREST  (0X0 << 13)
#define MXCSR_RC_DOWNWARD   (0x1 << 13)
#define MXCSR_RC_UPWARD     (0x2 << 13)
#define MXCSR_RC_TOWARDZERO (0x3 << 13)
#define MXCSR_RC_MASK       MXCSR_RC_TOWARDZERO

/* MXCSR control word */
#define MXCSR_CW_MASK       (0xFFFF)
#define MXCSR_CW_RC_MASK    (MXCSR_CW_MASK ^ MXCSR_RC_MASK)

/* fenv_At struct definition */
#define FPUCW_MEMBER_OFFSET (0x0)
#define MXCSR_MEMBER_OFFSET (0x1C)

/* user rounding control flags */
#define FE_RC_TONEAREST     FPU_RC_TONEAREST
#define FE_RC_DOWNWARD      FPU_RC_DOWNWARD
#define FE_RC_UPWARD        FPU_RC_UPWARD
#define FE_RC_TOWARDZERO    FPU_RC_TOWARDZERO
#define FE_RC_MASK          FPU_RC_MASK

/* user default float environment */
#define FE_DFL_ENV          (-1)

	/******************************************************/
	/*                                                    */
	/* FSTCW:   check for pending floating-point          */
	/*          exceptions, then store FPU control word.  */
	/*                                                    */
	/* FNSTCW:  store FPU control word without first      */
	/*          checking for pending floating-point       */
	/*          exceptions.                               */
	/*                                                    */
	/* FSTSW:   check for pending floating-point          */
	/*          exceptions, then store FPU status word.   */
	/*                                                    */
	/* FNSTSW:  store FPU status word without first       */
	/*          checking for pending floating-point       */
	/*          exceptions.                               */
	/*                                                    */
	/* FCLEX:   check for pending floating-point          */
	/*          exceptions, then clear FPU exception      */
	/*          flags.                                    */
	/*                                                    */
	/* FNCLEX:  clear FPU exception flags without first   */
	/*          checking for pending floating-point       */
	/*          exceptions.                               */
	/*                                                    */
	/* FLDCW:   set the FPU Control Word from memory.     */
	/*                                                    */
	/* FLDENV:  set the FPU Environment from memory.      */
	/*                                                    */
	/* STMXCSR: store the state of the MXCSR register;    */
	/*          the register's reserved bits are set to   */
	/*          zero in the destination.                  */
	/*                                                    */
	/* LDMXCSR: set the MXCSR environment from memory.    */
	/*                                                    */
	/******************************************************/

	/**********************************************/
	/* int fetestexcept(int exflags);             */
	/*                                            */
	/* query which exception flags, as indicated  */
	/* by the exflags mask, are currently set.    */
	/*                                            */
	/**********************************************/

	.text
	.def fetestexcept; .scl 2; .type 32; .endef
	.global fetestexcept

	.cfi_startproc;
fetestexcept:
	and $FE_ALL_EXCEPT,%ecx     /* normalize exflags    */
	push %r10                   /* temporary state var  */
	stmxcsr (%rsp)              /* store mxcsr state    */
	pop %rdx                    /* copy state to rdx    */
	fnstsw %ax                  /* store fpu state      */
	or %edx,%eax                /* fpu+mxcsr state      */
	and %ecx,%eax               /* desired flags only   */
	ret
	.cfi_endproc


	/**********************************************/
	/* int feclearexcept(int exflags);            */
	/*                                            */
	/* clear specific fpu exception flags, as     */
	/* indicated by the exflags mask.             */
	/*                                            */
	/**********************************************/

	.text
	.def feclearexcept; .scl 2; .type 32; .endef
	.global feclearexcept

	.cfi_startproc;
feclearexcept:
	fnstsw %ax                  /* store fpu state      */
	and $FE_ALL_EXCEPT,%ecx     /* normalize exflags    */
	and $FE_ALL_EXCEPT,%eax     /* normalize fpu state  */
	test %ecx,%eax              /* test exflags,state   */
	jz 1f                       /* state already clear? */
	fnclex                      /* clear fpu state      */
1:	push %rdx                   /* temporary state var  */
	stmxcsr (%rsp)              /* store mxcsr state    */
	pop %rdx                    /* copy state to rdx    */
	or %eax,%edx                /* fpu+mxcsr state      */
	test %ecx,%edx              /* test exflags,state   */
	jz 1f                       /* state already clear? */
	not %ecx                    /* clear desired flags- */
	and %ecx,%edx               /* -from mxcsr state    */
	push %rdx                   /* modified mxcsr var   */
	ldmxcsr (%rsp)              /* update mxcsr         */
	pop %rdx                    /* dealloc mxcsr var    */
1:	xor %eax,%eax               /* ret zero either way  */
	ret
	.cfi_endproc


	/**********************************************/
	/* int feraiseexcept(int exflags);            */
	/*                                            */
	/* set specific fpu exception flags, as       */
	/* indicated by the exflags mask.             */
	/*                                            */
	/* it is enough to set the flags only in      */
	/* either mxcsr or the [legacy] x87 fpu,      */
	/* specifically since fetestexcept() does     */
	/* take both into account.                    */
	/*                                            */
	/**********************************************/

	.text
	.def feraiseexcept; .scl 2; .type 32; .endef
	.global feraiseexcept

	.cfi_startproc;
feraiseexcept:
	and $FE_ALL_EXCEPT,%ecx     /* normalize exflags    */
	stmxcsr -0x8(%rsp)          /* store mxcsr state    */
	or %ecx,-0x8(%rsp)          /* set desired flags    */
	ldmxcsr -0x8(%rsp)          /* update mxcsr         */
	xor %eax,%eax
	ret
	.cfi_endproc


	/**********************************************/
	/* int fegetround(void);                      */
	/*                                            */
	/* obtain the current rounding mode, which    */
	/* should be one of: round-to-neareset,       */
	/* round-downwards, round-upwards, or         */
	/* round-toward-zero.                         */
	/*                                            */
	/* when we set the rounding mode we set both  */
	/* mxcsr and the [legacy] x87 fpu, and it     */
	/* thus suffices to obtain the mode from      */
	/* either, which is mxcsr in our case.        */
	/**********************************************/

	.text
	.def fegetround; .scl 2; .type 32; .endef
	.global fegetround

	.cfi_startproc;
fegetround:
	push %rdx                   /* temporary state var  */
	stmxcsr (%rsp)              /* store mxcsr state    */
	pop %rax                    /* copy state to rax    */
	and $MXCSR_RC_MASK,%rax     /* MXCSR RC bits only   */
	shr $0x3,%rax               /* MXCSR --> FE bits    */
	ret
	.cfi_endproc


	/**********************************************/
	/* int fesetround(int rcmode);                */
	/*                                            */
	/* set the current rounding mode, which       */
	/* should be one of: round-to-neareset,       */
	/* round-downwards, round-upwards, or         */
	/* round-toward-zero.                         */
	/**********************************************/

	.text
	.def __fesetround; .scl 2; .type 32; .endef
	.global __fesetround

	.cfi_startproc;
__fesetround:
	push %rdx                       /* alloc control var    */
	and $FE_RC_MASK,%ecx            /* normalize rcarg      */
	fnstcw (%rsp)                   /* current control word */
	andw $FPU_CW_RC_MASK,(%rsp)     /* control word only    */
	or %ecx,(%rsp)                  /* set rc bits to rcarg */
	fldcw (%rsp)                    /* set fpu control word */
	shl $0x3,%ecx                   /* rcarg: FPU --> MXCSR */
	stmxcsr (%rsp)                  /* current mxcsr reg    */
	andw $MXCSR_CW_RC_MASK,(%rsp)   /* control word only    */
	or %ecx,(%rsp)                  /* set rc bits to rcarg */
	ldmxcsr (%rsp)                  /* set mxcsr ctrl word  */
	pop %rdx                        /* dealloc control var  */
	xor %eax,%eax
	ret
	.cfi_endproc


	/**********************************************/
	/* int fegetenv(fenv_t *);                    */
	/*                                            */
	/* popualte a structure of type fenv_t with   */
	/* the current X87 FPU environmtnet (fnstenv) */
	/* as well as MXCSR environment (stmxcsr).    */
	/**********************************************/

	.text
	.def fegetenv; .scl 2; .type 32; .endef
	.global fegetenv

	.cfi_startproc;
fegetenv:
	fnstenv FPUCW_MEMBER_OFFSET(%rcx)
	stmxcsr MXCSR_MEMBER_OFFSET(%rcx)
	xor %eax,%eax
	ret
	.cfi_endproc


	/**********************************************/
	/* int fesetenv(cont fenv_t *);               */
	/*                                            */
	/* (re)initialize the X87 FPU and MXCSR       */
	/* environments from a user structure of      */
	/* type fenv_t.                               */
	/*                                            */
	/* if the pointer to the fenv_t structure is  */
	/* FE_DFL_ENV, reset the X87 FPU and MXCSR    */
	/* environments to theit default values as    */
	/* defined by the architecture.               */
	/*                                            */
	/*   .__control_word  = 0x037f,               */
	/*   .__unused1       = N/A,                  */
	/*   .__status_word   = 0x0,                  */
	/*   .__unused2       = N/A,                  */
	/*   .__tags          = 0xffff,               */
	/*   .__unused3       = N/A,                  */
	/*   .__eip           = 0x0,                  */
	/*   .__cs_selector   = 0x0,                  */
	/*   .__opcode        = 0x0,                  */
	/*   .__unused4       = N/A,                  */
	/*   .__data_offset   = 0x0,                  */
	/*   .__data_selector = 0x0,                  */
	/*   .__unused5       = N/A,                  */
	/*   .__mxcsr         = 0x1f80                */
	/*                                            */
	/**********************************************/

	.text
	.def fesetenv; .scl 2; .type 32; .endef
	.global fesetenv

	.cfi_startproc;
fesetenv:
	/* prolog */
	xor %eax,%eax

	/* use fenv_t or reset to default values? */
	cmpq $FE_DFL_ENV,%rcx
	jz 1f

	/* use the user-provided fenv_t */
	fldenv  FPUCW_MEMBER_OFFSET(%rcx)
	ldmxcsr MXCSR_MEMBER_OFFSET(%rcx)
	ret

	/* reset environments to the architecture-defined defaults */
1:	subq $0x20,%rsp

	/* X87 FPU */
	movq $0x037f,(0x0)(%rsp)
	movq $0xffff,(0x8)(%rsp)
	movq $0x0,(0x10)(%rsp)
	movq $0x0,(0x18)(%rsp)
	fldenv (%rsp)

	/* MXCSR */
	movq $0x1f80,(%rsp)
	ldmxcsr (%rsp)

	/* all done */
	addq $0x20,%rsp
	ret
	.cfi_endproc


	.section .got$fetestexcept
	.global __imp_fetestexcept
__imp_fetestexcept:
	.quad fetestexcept
	.linkonce discard


	.section .got$feclearexcept
	.global __imp_feclearexcept
__imp_feclearexcept:
	.quad feclearexcept
	.linkonce discard


	.section .got$feraiseexcept
	.global __imp_feraiseexcept
__imp_feraiseexcept:
	.quad feraiseexcept
	.linkonce discard


	.section .got$fegetround
	.global __imp_fegetround
__imp_fegetround:
	.quad fegetround
	.linkonce discard


	.section .got$__fesetround
	.global __imp___fesetround
__imp___fesetround:
	.quad __fesetround
	.linkonce discard


	.section .got$fegetenv
	.global __imp_fegetenv
__imp_fegetenv:
	.quad fegetenv
	.linkonce discard


	.section .got$fesetenv
	.global __imp_fesetenv
__imp_fesetenv:
	.quad fesetenv
	.linkonce discard
