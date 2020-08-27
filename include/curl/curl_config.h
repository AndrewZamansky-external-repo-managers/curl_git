#ifndef HEADER_CURL_CONFIG_H
#define HEADER_CURL_CONFIG_H

#include "project_config.h"
#include "stdint.h"
#include "sys/time.h"


#ifdef CONFIG_USE_INTERNAL_SOCKETS_IMPLEMENTATION

	#include "sys/socket.h"
	#include "sys/netdb.h"

	#define HAVE_SETSOCKOPT_SO_NONBLOCK
	#if defined(COMPILING_FOR_LINUX_HOST)
		#include <unistd.h>
	#endif
	#define HAVE_CLOSESOCKET 1
#else
	#include <netdb.h>
	#include <unistd.h>
	#include <string.h>
	#include <sys/un.h>
	#include <fcntl.h>
	#include <sys/socket.h>
	#include <sys/socket.h>
	#define HAVE_FCNTL_O_NONBLOCK  1
	#define HAVE_SYS_SOCKET_H  1
	#define HAVE_NETINET_TCP_H  1

#endif

#define HAVE_ERRNO_H 1

#define HAVE_SYS_STAT_H 1

#define HAVE_SELECT 1

#define HAVE_LONGLONG

#define HAVE_ASSERT_H	1

#define HAVE_STRTOK_R	1

#define HAVE_STRUCT_TIMEVAL 1
#define HAVE_SYS_TIME_H 1

#ifdef CONFIG_FREE_RTOS
	#define OS "freeRTOS"
#endif

/* The size of `int', as computed by sizeof. */
#define SIZEOF_INT 4

/* The size of `off_t', as computed by sizeof. */
#define SIZEOF_OFF_T 8

/* The size of `short', as computed by sizeof. */
#define SIZEOF_SHORT 2

/* The size of `size_t', as computed by sizeof. */
#define SIZEOF_SIZE_T 4

/* The size of `time_t', as computed by sizeof. */
#define SIZEOF_TIME_T 4

/* The size of `void*', as computed by sizeof. */
#define SIZEOF_VOIDP 4


/* Define to 1 if you have the send function. */
#define HAVE_SEND 1

/* Define to the type qualifier of arg 2 for send. */
#define SEND_QUAL_ARG2 const

/* Define to the type of arg 1 for send. */
#define SEND_TYPE_ARG1 int

/* Define to the type of arg 2 for send. */
#define SEND_TYPE_ARG2 void *

/* Define to the type of arg 3 for send. */
#define SEND_TYPE_ARG3 size_t

/* Define to the type of arg 4 for send. */
#define SEND_TYPE_ARG4 int

/* Define to the function return type for send. */
#define SEND_TYPE_RETV int


/* Define to 1 if you have the recv function. */
#define HAVE_RECV 1

/* Define to the type of arg 1 for recv. */
#define RECV_TYPE_ARG1 int

/* Define to the type of arg 2 for recv. */
#define RECV_TYPE_ARG2 void *

/* Define to the type of arg 3 for recv. */
#define RECV_TYPE_ARG3 size_t

/* Define to the type of arg 4 for recv. */
#define RECV_TYPE_ARG4 int

/* Define to the function return type for recv. */
#define RECV_TYPE_RETV int

#define HAVE_SOCKET	1

#define HAVE_VARIADIC_MACROS_C99	1

#define HAVE_STRING_H	1
#define HAVE_MEMRCHR	1
#define  HAVE_STRDUP	1
#define HAVE_STRERROR_R	1

#if defined(__gnu_linux__) || (__GNUC__ >= 9)
    #define HAVE_STDBOOL_H
    #define HAVE_BOOL_T
#else
	#error "add bool support. make sure it not \
				conflicting with bool in other libs(like in mbedtls there is \
						 include for stdbool.h ) "
#endif

#ifdef COMPILING_FOR_LINUX_HOST
	#define HAVE_POSIX_STRERROR_R 1
	#if __x86_64__
		#define SIZEOF_LONG 8
		#define SIZEOF_CURL_OFF_T 8
	#elif defined(__i386__)
		#define SIZEOF_LONG 4
		#define SIZEOF_CURL_OFF_T 4
	#else
		#error "unknown arch"
	#endif
	#define OS "linux"
#else
	#if defined(CONFIG_CORTEX_M4)
		#define SIZEOF_LONG 4
		#define SIZEOF_CURL_OFF_T 4
		#define SIZEOF_LONG_LONG  8
		#if defined(CONFIG_I94XXX)// defined in BSP nvttypes.h
			#undef FALSE
			#define FALSE 0
			#undef TRUE
			#define TRUE 1
		#endif
	#endif
	#define HAVE_GLIBC_STRERROR_R 1
#endif

#define CURL_SOCKET_HASH_TABLE_SIZE 97

#endif /* HEADER_CURL_CONFIG_VXWORKS_H */
