#ifndef _SYS_LDSO_H
#define _SYS_LDSO_H

#ifdef __cplusplus
extern "C" {
#endif

void * __dldopen(int, int);
void * __dlsopen(const char *, int);

#ifdef __cplusplus
}
#endif

#endif
