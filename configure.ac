# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.59)
AC_INIT([RT::Action::NotifyGroup],[0.01],[cubic@wildgate.miee.ru])

AC_CONFIG_SRCDIR([lib/RT/Action/NotifyGroup.pm])

# Checks for programs.
#AC_PROG_INSTALL

AC_ARG_WITH(rt-lib,
            AC_HELP_STRING([--with-rt-lib=/path/to/rt/lib],
                           [path to your rt lib dir]),
            RT_LIB_PATH=$withval,
            RT_LIB_PATH=/opt/rt3/lib)
AC_SUBST(RT_LIB_PATH)

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

AC_CONFIG_FILES([
		 sbin/rt-notify-group-admin],
		[chmod ug=rx,o= sbin/rt-notify-group-admin
		]
	       )
AC_OUTPUT
