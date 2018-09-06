
INCLUDE_THIS_COMPONENT := $(CONFIG_INCLUDE_CURL)

ifeq ($(strip $(CONFIG_INCLUDE_CURL)),y)

    EXPANDED_MAKEFILE_LIST := $(realpath $(MAKEFILE_LIST))
    CURR_FILE_SUFFIX :=curl_git/Makefile.uc.mk
    CURR_MAKEFILE :=$(filter %$(CURR_FILE_SUFFIX), $(EXPANDED_MAKEFILE_LIST))
    CURR_COMPONENT_DIR := $(patsubst %/Makefile.uc.mk,%,$(CURR_MAKEFILE))

    #test if current commit and branch of nghttp2 git is
    # the same as required by application
    CURR_GIT_REPO_DIR :=$(CURR_COMPONENT_DIR)
    CURR_GIT_COMMIT_HASH_VARIABLE :=CONFIG_CURL_GIT_MANAGER_COMMIT_HASH
    include $(MAKEFILES_ROOT_DIR)/_include_functions/git_prebuild_repo_check.mk

    CURL_GIT_COMMIT_HASH :="eb8138405a3f747f2c236464932f72e918946f68"


    CURL_PATH :=$(EXTERNAL_SOURCE_ROOT_DIR)/curl
    ifeq ("$(wildcard $(CURL_PATH))","")
        $(info   )
        $(info --- CURL path $(CURL_PATH) dont exists )
        $(info --- get repo from andew zamansky or from https://github.com/curl/curl  )
        $(info --- make sure that .git directory is located in $(CURL_PATH)/  after unpacking   )
        $(error )
    endif

    #test if current commit and branch of curl git is
    # the same as required by application
    CURR_GIT_REPO_DIR :=$(CURL_PATH)
    CURR_GIT_COMMIT_HASH_VARIABLE :=CURL_GIT_COMMIT_HASH
    #CURR_GIT_BUNDLE :=$(CURR_COMPONENT_DIR)/curl.bundle
    include $(MAKEFILES_ROOT_DIR)/_include_functions/git_prebuild_repo_check.mk
    
    DUMMY := $(call ADD_TO_GLOBAL_INCLUDE_PATH , $(CURL_PATH)/include/curl)

    ifeq ($(findstring WINDOWS,$(COMPILER_HOST_OS)),WINDOWS)
        ifeq ($(strip $(CONFIG_MICROSOFT_COMPILER)),y)
            DUMMY := $(call ADD_TO_GLOBAL_LIBRARIES , Ws2_32.lib )
            DUMMY := $(call ADD_TO_GLOBAL_LIBRARIES_PATH , var )
        endif
    endif



    INCLUDE_DIR +=$(CURR_COMPONENT_DIR)/include
    INCLUDE_DIR +=$(CURR_COMPONENT_DIR)/include/curl
    INCLUDE_DIR +=$(CURL_PATH)/include
    INCLUDE_DIR +=$(AUTO_GENERATED_FILES_DIR)


    DEFINES += CURL_STATICLIB

    #DEFINES += DEBUG_HTTP2
    #DEFINES += DEBUGBUILD

    ifeq ($(strip $(CONFIG_CUSTOM_SOCKET_LAYER)),y)
        DEFINES += USE_CUSTOM_SOCKET_IN_COMPILED_MODULE
    endif

    ifeq ($(strip $(CONFIG_CURL_USE_CUSTOM_CURL_CONFIG_H)),y)
        DEFINES += HAVE_CONFIG_H
    endif

    ifeq ($(strip $(CONFIG_CURL_USE_CA_BUNDLE)),y)
        DEFINES += CURL_CA_BUNDLE=$(CONFIG_CURL_CA_BUNDLE_FILE)
    endif

    ifeq ($(strip $(CONFIG_CURL_USE_UNIX_SOCKETS)),y)
        DEFINES += USE_UNIX_SOCKETS
    endif

    ifneq ($(strip $(CONFIG_CURL_HTTP_PROTOCOL_SUPPORT)),y)
        DEFINES += CURL_DISABLE_HTTP
    endif
    ifneq ($(strip $(CONFIG_CURL_FTP_PROTOCOL_SUPPORT)),y)
        DEFINES += CURL_DISABLE_FTP
    endif
    ifneq ($(strip $(CONFIG_CURL_TELNET_PROTOCOL_SUPPORT)),y)
        DEFINES += CURL_DISABLE_TELNET
    endif
    ifneq ($(strip $(CONFIG_CURL_DICT_PROTOCOL_SUPPORT)),y)
        DEFINES += CURL_DISABLE_DICT
    endif
    ifneq ($(strip $(CONFIG_CURL_TFTP_PROTOCOL_SUPPORT)),y)
        DEFINES += CURL_DISABLE_TFTP
    endif
    ifneq ($(strip $(CONFIG_CURL_FILE_PROTOCOL_SUPPORT)),y)
        DEFINES += CURL_DISABLE_FILE
    endif
    ifneq ($(strip $(CONFIG_CURL_LDAP_PROTOCOL_SUPPORT)),y)
        DEFINES += CURL_DISABLE_LDAP
    endif
    ifneq ($(strip $(CONFIG_CURL_IMAP_PROTOCOL_SUPPORT)),y)
        DEFINES += CURL_DISABLE_IMAP
    endif
    ifneq ($(strip $(CONFIG_CURL_SMTP_PROTOCOL_SUPPORT)),y)
        DEFINES += CURL_DISABLE_SMTP
    endif
    ifneq ($(strip $(CONFIG_GOPHER_PROTOCOL_SUPPORT)),y)
        DEFINES += CURL_DISABLE_GOPHER
    endif
    ifneq ($(strip $(CONFIG_CURL_SMB_PROTOCOL_SUPPORT)),y)
        DEFINES += CURL_DISABLE_SMB
    endif
    ifneq ($(strip $(CONFIG_CURL_POP3_PROTOCOL_SUPPORT)),y)
        DEFINES += CURL_DISABLE_POP3
    endif
    ifneq ($(strip $(CONFIG_CURL_RTSP_PROTOCOL_SUPPORT)),y)
        DEFINES += CURL_DISABLE_RTSP
    endif

    ifneq ($(strip $(CONFIG_CURL_ENABLE_PROXY)),y)
        DEFINES += CURL_DISABLE_PROXY
    endif

    ifeq ($(strip $(CONFIG_CURL_ENABLE_COOKIES)),y)
        SRC += lib/cookie.c
    else
        DEFINES += CURL_DISABLE_COOKIES
    endif


    ifeq ($(strip $(CONFIG_CURL_ENABLE_VERBOSE_STRINGS)),y)
        DEFINES += Curl_nop_stmt=printf
    else
        DEFINES += CURL_DISABLE_VERBOSE_STRINGS
    endif

    ifeq ($(strip $(CONFIG_CURL_ENABLE_DEBUG)),y)
        DEFINES += DEBUGBUILD
    endif

    ifeq ($(strip $(CONFIG_CURL_USE_OPENSSL)),y)
        DEFINES += USE_OPENSSL
    endif


    ifeq ($(strip $(CONFIG_CURL_USE_WOLFSSL)),y)
        DEFINES += USE_CYASSL
    endif

    ifeq ($(strip $(CONFIG_CURL_USE_NGHTTP2)),y)
        DEFINES += USE_NGHTTP2
    endif

    ifneq ($(strip $(CONFIG_CURL_ENABLE_CRYPTO_AUTHENTICATION)),y)
        DEFINES += CURL_DISABLE_CRYPTO_AUTH
    endif

    ifneq ($(strip $(CONFIG_CURL_DEFAULT_RECIEVE_BUFFER_SIZE)),y)#if NOT defined
        DEFINES += CURL_MAX_WRITE_SIZE=$(CONFIG_CURL_RECIEVE_BUFFER_SIZE)
    endif

    ifneq ($(strip $(CONFIG_CURL_DEFAULT_HTTP2_BUFFER_SIZE)),y)#if NOT defined
        #DEFINES += H2_BUFSIZE=$(CONFIG_CURL_HTTP2_BUFFER_SIZE)
    endif

    ifeq ($(strip $(CONFIG_GCC)),y)
        DEFINES += HAVE_STRTOLL
    endif

    DEFINES += CURL_STRICTER
    ifeq ($(CONFIG_HOST),y)
        DEFINES += COMPILING_FOR_HOST
        ifeq ($(findstring WINDOWS,$(COMPILER_HOST_OS)),WINDOWS)
            ifdef CONFIG_MICROSOFT_COMPILER
                #disable warning C4127: conditional expression is constant
                CFLAGS += /wd4127
                DEFINES += _CRT_SECURE_NO_WARNINGS
            endif
            DEFINES += COMPILING_FOR_WINDOWS_HOST
        else
            DEFINES += COMPILING_FOR_LINUX_HOST
        endif
    endif

    #ASMFLAGS =



    SRC += lib/easy.c
    SRC += lib/url.c
    SRC += lib/strcase.c
    SRC += lib/getenv.c
    SRC += lib/escape.c
    SRC += lib/slist.c
    SRC += lib/llist.c
    SRC += lib/hash.c
    SRC += lib/timeval.c
    SRC += lib/curl_addrinfo.c
    SRC += lib/multi.c
    SRC += lib/hostasyn.c
    SRC += lib/sendf.c
    SRC += lib/inet_pton.c
    SRC += lib/curl_threads.c
    SRC += lib/connect.c
    SRC += lib/mprintf.c
    SRC += lib/hostip.c
    SRC += lib/getinfo.c
    SRC += lib/select.c
    SRC += lib/conncache.c
    SRC += lib/if2ip.c
    SRC += lib/strerror.c
    SRC += lib/nonblock.c
    SRC += lib/inet_ntop.c
    SRC += lib/progress.c
    SRC += lib/warnless.c
    SRC += lib/version.c
    SRC += lib/strdup.c
    SRC += lib/share.c
    SRC += lib/hostip4.c
    SRC += lib/splay.c
    SRC += lib/wildcard.c
    SRC += lib/transfer.c
    SRC += lib/speedcheck.c
    SRC += lib/pipeline.c
    SRC += lib/netrc.c
    SRC += lib/dotdot.c
    SRC += lib/fileinfo.c
    SRC += lib/setopt.c
    SRC += lib/mime.c
    SRC += lib/curl_ctype.c
    SRC += lib/content_encoding.c
    SRC += lib/http_proxy.c
    SRC += lib/strtoofft.c

    # followin files compiled always but contets of each are used
    # according to following defines :  CURLRES_ARES ,
    # CURLRES_THREADED , CURLRES_SYNCH
    SRC += lib/hostsyn.c
    SRC += lib/asyn-thread.c
    SRC += lib/asyn-ares.c

    ifeq ($(findstring WINDOWS,$(COMPILER_HOST_OS)),WINDOWS)
        SRC += lib/system_win32.c
        SRC += lib/strtok.c
    endif

    ifeq ($(strip $(CONFIG_CURL_HTTP_PROTOCOL_SUPPORT)),y)
        SRC += lib/http.c
        SRC += lib/http_digest.c
        SRC += lib/http_ntlm.c
        SRC += lib/http_chunks.c
        SRC += lib/base64.c
        SRC += lib/md5.c
        SRC += lib/rand.c
        SRC += lib/parsedate.c
        SRC += lib/formdata.c
        SRC += lib/hmac.c
        SRC += lib/curl_endian.c
        SRC += lib/curl_ntlm_core.c
        SRC += lib/curl_des.c
        SRC += lib/curl_gethostname.c


        SRC += lib/vauth/digest.c
        SRC += lib/vauth/vauth.c
        SRC += lib/vauth/ntlm.c
    endif


    INCLUDE_DIR +=$(CURL_PATH)/lib
    ifeq ($(strip $(CONFIG_CURL_USE_OPENSSL)),y)
        SRC += lib/vtls/openssl.c
        SRC += lib/hostcheck.c
        DEFINES += $(filter OPENSSL%, $(GLOBAL_INCLUDE_DIR))
    endif


    ifeq ($(strip $(CONFIG_CURL_USE_NGHTTP2)),y)
        SRC += lib/http2.c
    endif

    ifeq ($(strip $(CONFIG_CURL_USE_WOLFSSL)),y)
        DEFINES += HAVE_CYASSL_ERROR_SSL_H
        INCLUDE_DIR +=$(WOLFSSL_PATH)
        SRC += lib/vtls/cyassl.c
    endif


    SRC += lib/vtls/vtls.c

    VPATH += | $(CURL_PATH)

    DISABLE_GLOBAL_INCLUDES_PATH := y

endif

include $(COMMON_CC)
