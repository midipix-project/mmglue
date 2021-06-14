dnl modern.m4: a modern and simple framework for using the m4 macro language
dnl
dnl This file is covered by COPYING.SOFORT.
dnl
dnl 1) make all standard m4 builtins m4_ prefixed.
dnl 2) set the left-bracket and right-bracket symbols the begin-quote and end-quote strings.
dnl 3) make a single underscore symbol the equivalent of the standard dnl builtin.
dnl 4) provide the m4_toupper(), m4_tolower(), and m4_pathvar() macros.
dnl 5) provide the m4_srclist() and m4_srcitem() macros.
dnl 6) provide the m4_fillerdots(), m4_fillerdash(), and m4_fillerline() macros.
dnl 7) provide the m4_whitespace() and m4_spacealign() macros.
dnl 8) provide the m4_alignlen(), m4_leftalign(), and m4_rightalign() macros.
dnl 9) provide the m4_tab(), m4_tabtab(), and m4_tabtabtab() macros.
dnl
divert(-1)

define(m4_changecom,defn(`changecom'))
define(m4_changequote,defn(`changequote'))
define(m4_decr,defn(`decr'))
define(m4_define,defn(`define'))
define(m4_defn,defn(`defn'))
define(m4_divert,defn(`divert'))
define(m4_divnum,defn(`divnum'))
define(m4_dnl,defn(`dnl'))
define(m4_dumpdef,defn(`dumpdef'))
define(m4_errprint,defn(`errprint'))
define(m4_eval,defn(`eval'))
define(m4_ifdef,defn(`ifdef'))
define(m4_ifelse,defn(`ifelse'))
define(m4_include,defn(`include'))
define(m4_incr,defn(`incr'))
define(m4_index,defn(`index'))
define(m4_len,defn(`len'))
define(m4_m4exit,defn(`m4exit'))
define(m4_m4wrap,defn(`m4wrap'))
define(m4_maketemp,defn(`maketemp'))
define(m4_mkstemp,defn(`mkstemp'))
define(m4_popdef,defn(`popdef'))
define(m4_pushdef,defn(`pushdef'))
define(m4_shift,defn(`shift'))
define(m4_sinclude,defn(`sinclude'))
define(m4_substr,defn(`substr'))
define(m4_syscmd,defn(`syscmd'))
define(m4_sysval,defn(`sysval'))
define(m4_traceoff,defn(`traceoff'))
define(m4_traceon,defn(`traceon'))
define(m4_translit,defn(`translit'))
define(m4_undefine,defn(`undefine'))
define(m4_undivert,defn(`undivert'))

m4_changequote([,])

m4_undefine([changecom])
m4_undefine([changequote])
m4_undefine([decr])
m4_undefine([define])
m4_undefine([defn])
m4_undefine([divert])
m4_undefine([divnum])
m4_undefine([dnl])
m4_undefine([dumpdef])
m4_undefine([errprint])
m4_undefine([eval])
m4_undefine([ifdef])
m4_undefine([ifelse])
m4_undefine([include])
m4_undefine([incr])
m4_undefine([index])
m4_undefine([len])
m4_undefine([m4exit])
m4_undefine([m4wrap])
m4_undefine([maketemp])
m4_undefine([mkstemp])
m4_undefine([popdef])
m4_undefine([pushdef])
m4_undefine([shift])
m4_undefine([sinclude])
m4_undefine([substr])
m4_undefine([syscmd])
m4_undefine([sysval])
m4_undefine([traceoff])
m4_undefine([traceon])
m4_undefine([translit])
m4_undefine([undefine])
m4_undefine([undivert])

m4_define([_],m4_defn([m4_dnl]))

m4_define([m4_toupper],[m4_translit([[$1]],[[abcdefghijklmnopqrstuvwxyz]],[[ABCDEFGHIJKLMNOPQRSTUVWXYZ]])])
m4_define([m4_tolower],[m4_translit([[$1]],[[ABCDEFGHIJKLMNOPQRSTUVWXYZ]],[[abcdefghijklmnopqrstuvwxyz]])])
m4_define([m4_pathvar],[m4_translit(m4_toupper([[$1]]),[/],[_])])

m4_define([m4_srclist],[[$1] = \])
m4_define([m4_srcitem],[m4_tab[$1] \])

m4_define([m4_fillerdots],[................................])
m4_define([m4_fillerdash],[--------------------------------])
m4_define([m4_fillerline],[m4_fillerdots[]m4_fillerdots[]m4_fillerdots[]])

m4_define([m4_whitespace],[m4_translit(m4_fillerdots,[[.]],[[ ]])])
m4_define([m4_spacealign],[m4_translit(m4_fillerline,[[.]],[[ ]])])

m4_define([m4_alignlen],[m4_eval([$1]-m4_len([$2]))])
m4_define([m4_leftalign],[m4_substr(m4_spacealign,0,m4_alignlen([$1],[$2]))[$2]])
m4_define([m4_rightalign],[[$2]m4_substr(m4_spacealign,0,m4_alignlen([$1],[$2]))])


m4_define([m4_tab],_
	[$1]))

m4_define([m4_tabtab],_
		[$1])

m4_define([m4_tabtabtab],_
			[$1])

m4_divert(0)_
