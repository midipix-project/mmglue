/**************************************************************************/
/*  mmglue: midipix architecture- and target-specific bits for musl libc  */
/*  Copyright (C) 2013--2023  SysDeer Technologies, LLC                   */
/*  Released under GPLv2 and GPLv3; see COPYING.MMGLUE.                   */
/**************************************************************************/

typedef unsigned int uint32_t;

int dlstart(
	void *		hinstance,
	uint32_t	reason,
	void *		reserved)
{
	return 1;
}

