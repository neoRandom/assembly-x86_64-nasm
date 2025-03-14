%ifndef ESSENTIAL
%define ESSENTIAL


; =======================================================================================
; =============================          CONSTANTS          =============================
; =======================================================================================

NULL equ 0

STDIN_FILENO    equ 0
STDOUT_FILENO   equ 1
STDERR_FILENO   equ 2
STDIN   equ 0
STDOUT  equ 1
STDERR  equ 2
 
O_RDONLY    equ 0
O_WRONLY    equ 1
O_RDWR      equ 2
 
O_CREAT     equ 64
O_EXCL      equ 128
O_NOCTTY    equ 256
O_TRUNC     equ 512
O_APPEND    equ 1024
O_NONBLOCK  equ 2048
O_NDELAY    equ 2048
O_DSYNC     equ 4096
O_ASYNC     equ 8192
O_DIRECT    equ 16384
O_DIRECTORY equ 65536
O_NOFOLLOW  equ 131072
O_NOATIME   equ 262144
O_CLOEXEC   equ 524288
O_SYNC      equ 1052672
O_PATH      equ 2097152
O_TMPFILE   equ 4259840
 
O_LARGEFILE equ 0

SYS_READ    equ 0
SYS_WRITE   equ 1
SYS_OPEN    equ 2
SYS_CLOSE   equ 3
SYS_STAT    equ 4
SYS_FSTAT   equ 5
SYS_LSTAT   equ 6
SYS_POLL    equ 7
SYS_LSEEK   equ 8
SYS_MMAP    equ 9
SYS_MPROTECT    equ 10
SYS_MUNMAP  equ 11
SYS_BRK equ 12
SYS_RT_SIGACTION    equ 13
SYS_RT_SIGPROCMASK  equ 14
SYS_RT_SIGRETURN    equ 15
SYS_IOCTL   equ 16
SYS_PREAD64 equ 17
SYS_PWRITE64    equ 18
SYS_READV   equ 19
SYS_WRITEV  equ 20
SYS_ACCESS  equ 21
SYS_PIPE    equ 22
SYS_SELECT  equ 23
SYS_SCHED_YIELD equ 24
SYS_MREMAP  equ 25
SYS_MSYNC   equ 26
SYS_MINCORE equ 27
SYS_MADVISE equ 28
SYS_SHMGET  equ 29
SYS_SHMAT   equ 30
SYS_SHMCTL  equ 31
SYS_DUP equ 32
SYS_DUP2    equ 33
SYS_PAUSE   equ 34
SYS_NANOSLEEP   equ 35
SYS_GETITIMER   equ 36
SYS_ALARM   equ 37
SYS_SETITIMER   equ 38
SYS_GETPID  equ 39
SYS_SENDFILE    equ 40
SYS_SOCKET  equ 41
SYS_CONNECT equ 42
SYS_ACCEPT  equ 43
SYS_SENDTO  equ 44
SYS_RECVFROM    equ 45
SYS_SENDMSG equ 46
SYS_RECVMSG equ 47
SYS_SHUTDOWN    equ 48
SYS_BIND    equ 49
SYS_LISTEN  equ 50
SYS_GETSOCKNAME equ 51
SYS_GETPEERNAME equ 52
SYS_SOCKETPAIR  equ 53
SYS_SETSOCKOPT  equ 54
SYS_GETSOCKOPT  equ 55
SYS_CLONE   equ 56
SYS_FORK    equ 57
SYS_VFORK   equ 58
SYS_EXECVE  equ 59
SYS_EXIT    equ 60
SYS_WAIT4   equ 61
SYS_KILL    equ 62
SYS_UNAME   equ 63
SYS_SEMGET  equ 64
SYS_SEMOP   equ 65
SYS_SEMCTL  equ 66
SYS_SHMDT   equ 67
SYS_MSGGET  equ 68
SYS_MSGSND  equ 69
SYS_MSGRCV  equ 70
SYS_MSGCTL  equ 71
SYS_FCNTL   equ 72
SYS_FLOCK   equ 73
SYS_FSYNC   equ 74
SYS_FDATASYNC   equ 75
SYS_TRUNCATE    equ 76
SYS_FTRUNCATE   equ 77
SYS_GETDENTS    equ 78
SYS_GETCWD  equ 79
SYS_CHDIR   equ 80
SYS_FCHDIR  equ 81
SYS_RENAME  equ 82
SYS_MKDIR   equ 83
SYS_RMDIR   equ 84
SYS_CREAT   equ 85
SYS_LINK    equ 86
SYS_UNLINK  equ 87
SYS_SYMLINK equ 88
SYS_READLINK    equ 89
SYS_CHMOD   equ 90
SYS_FCHMOD  equ 91
SYS_CHOWN   equ 92
SYS_FCHOWN  equ 93
SYS_LCHOWN  equ 94
SYS_UMASK   equ 95
SYS_GETTIMEOFDAY    equ 96
SYS_GETRLIMIT   equ 97
SYS_GETRUSAGE   equ 98
SYS_SYSINFO equ 99
SYS_TIMES   equ 100
SYS_PTRACE  equ 101
SYS_GETUID  equ 102
SYS_SYSLOG  equ 103
SYS_GETGID  equ 104
SYS_SETUID  equ 105
SYS_SETGID  equ 106
SYS_GETEUID equ 107
SYS_GETEGID equ 108
SYS_SETPGID equ 109
SYS_GETPPID equ 110
SYS_GETPGRP equ 111
SYS_SETSID  equ 112
SYS_SETREUID    equ 113
SYS_SETREGID    equ 114
SYS_GETGROUPS   equ 115
SYS_SETGROUPS   equ 116
SYS_SETRESUID   equ 117
SYS_GETRESUID   equ 118
SYS_SETRESGID   equ 119
SYS_GETRESGID   equ 120
SYS_GETPGID equ 121
SYS_SETFSUID    equ 122
SYS_SETFSGID    equ 123
SYS_GETSID  equ 124
SYS_CAPGET  equ 125
SYS_CAPSET  equ 126
SYS_RT_SIGPENDING   equ 127
SYS_RT_SIGTIMEDWAIT equ 128
SYS_RT_SIGQUEUEINFO equ 129
SYS_RT_SIGSUSPEND   equ 130
SYS_SIGALTSTACK equ 131
SYS_UTIME   equ 132
SYS_MKNOD   equ 133
SYS_USELIB  equ 134
SYS_PERSONALITY equ 135
SYS_USTAT   equ 136
SYS_STATFS  equ 137
SYS_FSTATFS equ 138
SYS_SYSFS   equ 139
SYS_GETPRIORITY equ 140
SYS_SETPRIORITY equ 141
SYS_SCHED_SETPARAM  equ 142
SYS_SCHED_GETPARAM  equ 143
SYS_SCHED_SETSCHEDULER  equ 144
SYS_SCHED_GETSCHEDULER  equ 145
SYS_SCHED_GET_PRIORITY_MAX  equ 146
SYS_SCHED_GET_PRIORITY_MIN  equ 147
SYS_SCHED_RR_GET_INTERVAL   equ 148
SYS_MLOCK   equ 149
SYS_MUNLOCK equ 150
SYS_MLOCKALL    equ 151
SYS_MUNLOCKALL  equ 152
SYS_VHANGUP equ 153
SYS_MODIFY_LDT  equ 154
SYS_PIVOT_ROOT  equ 155
SYS__SYSCTL equ 156
SYS_PRCTL   equ 157
SYS_ARCH_PRCTL  equ 158
SYS_ADJTIMEX    equ 159
SYS_SETRLIMIT   equ 160
SYS_CHROOT  equ 161
SYS_SYNC    equ 162
SYS_ACCT    equ 163
SYS_SETTIMEOFDAY    equ 164
SYS_MOUNT   equ 165
SYS_UMOUNT2 equ 166
SYS_SWAPON  equ 167
SYS_SWAPOFF equ 168
SYS_REBOOT  equ 169
SYS_SETHOSTNAME equ 170
SYS_SETDOMAINNAME   equ 171
SYS_IOPL    equ 172
SYS_IOPERM  equ 173
SYS_CREATE_MODULE   equ 174
SYS_INIT_MODULE equ 175
SYS_DELETE_MODULE   equ 176
SYS_GET_KERNEL_SYMS equ 177
SYS_QUERY_MODULE    equ 178
SYS_QUOTACTL    equ 179
SYS_NFSSERVCTL  equ 180
SYS_GETPMSG equ 181
SYS_PUTPMSG equ 182
SYS_AFS_SYSCALL equ 183
SYS_TUXCALL equ 184
SYS_SECURITY    equ 185
SYS_GETTID  equ 186
SYS_READAHEAD   equ 187
SYS_SETXATTR    equ 188
SYS_LSETXATTR   equ 189
SYS_FSETXATTR   equ 190
SYS_GETXATTR    equ 191
SYS_LGETXATTR   equ 192
SYS_FGETXATTR   equ 193
SYS_LISTXATTR   equ 194
SYS_LLISTXATTR  equ 195
SYS_FLISTXATTR  equ 196
SYS_REMOVEXATTR equ 197
SYS_LREMOVEXATTR    equ 198
SYS_FREMOVEXATTR    equ 199
SYS_TKILL   equ 200
SYS_TIME    equ 201
SYS_FUTEX   equ 202
SYS_SCHED_SETAFFINITY   equ 203
SYS_SCHED_GETAFFINITY   equ 204
SYS_SET_THREAD_AREA equ 205
SYS_IO_SETUP    equ 206
SYS_IO_DESTROY  equ 207
SYS_IO_GETEVENTS    equ 208
SYS_IO_SUBMIT   equ 209
SYS_IO_CANCEL   equ 210
SYS_GET_THREAD_AREA equ 211
SYS_LOOKUP_DCOOKIE  equ 212
SYS_EPOLL_CREATE    equ 213
SYS_EPOLL_CTL_OLD   equ 214
SYS_EPOLL_WAIT_OLD  equ 215
SYS_REMAP_FILE_PAGES    equ 216
SYS_GETDENTS64  equ 217
SYS_SET_TID_ADDRESS equ 218
SYS_RESTART_SYSCALL equ 219
SYS_SEMTIMEDOP  equ 220
SYS_FADVISE64   equ 221
SYS_TIMER_CREATE    equ 222
SYS_TIMER_SETTIME   equ 223
SYS_TIMER_GETTIME   equ 224
SYS_TIMER_GETOVERRUN    equ 225
SYS_TIMER_DELETE    equ 226
SYS_CLOCK_SETTIME   equ 227
SYS_CLOCK_GETTIME   equ 228
SYS_CLOCK_GETRES    equ 229
SYS_CLOCK_NANOSLEEP equ 230
SYS_EXIT_GROUP  equ 231
SYS_EPOLL_WAIT  equ 232
SYS_EPOLL_CTL   equ 233
SYS_TGKILL  equ 234
SYS_UTIMES  equ 235
SYS_VSERVER equ 236
SYS_MBIND   equ 237
SYS_SET_MEMPOLICY   equ 238
SYS_GET_MEMPOLICY   equ 239
SYS_MQ_OPEN equ 240
SYS_MQ_UNLINK   equ 241
SYS_MQ_TIMEDSEND    equ 242
SYS_MQ_TIMEDRECEIVE equ 243
SYS_MQ_NOTIFY   equ 244
SYS_MQ_GETSETATTR   equ 245
SYS_KEXEC_LOAD  equ 246
SYS_WAITID  equ 247
SYS_ADD_KEY equ 248
SYS_REQUEST_KEY equ 249
SYS_KEYCTL  equ 250
SYS_IOPRIO_SET  equ 251
SYS_IOPRIO_GET  equ 252
SYS_INOTIFY_INIT    equ 253
SYS_INOTIFY_ADD_WATCH   equ 254
SYS_INOTIFY_RM_WATCH    equ 255
SYS_MIGRATE_PAGES   equ 256
SYS_OPENAT  equ 257
SYS_MKDIRAT equ 258
SYS_MKNODAT equ 259
SYS_FCHOWNAT    equ 260
SYS_FUTIMESAT   equ 261
SYS_NEWFSTATAT  equ 262
SYS_UNLINKAT    equ 263
SYS_RENAMEAT    equ 264
SYS_LINKAT  equ 265
SYS_SYMLINKAT   equ 266
SYS_READLINKAT  equ 267
SYS_FCHMODAT    equ 268
SYS_FACCESSAT   equ 269
SYS_PSELECT6    equ 270
SYS_PPOLL   equ 271
SYS_UNSHARE equ 272
SYS_SET_ROBUST_LIST equ 273
SYS_GET_ROBUST_LIST equ 274
SYS_SPLICE  equ 275
SYS_TEE equ 276
SYS_SYNC_FILE_RANGE equ 277
SYS_VMSPLICE    equ 278
SYS_MOVE_PAGES  equ 279
SYS_UTIMENSAT   equ 280
SYS_EPOLL_PWAIT equ 281
SYS_SIGNALFD    equ 282
SYS_TIMERFD_CREATE  equ 283
SYS_EVENTFD equ 284
SYS_FALLOCATE   equ 285
SYS_TIMERFD_SETTIME equ 286
SYS_TIMERFD_GETTIME equ 287
SYS_ACCEPT4 equ 288
SYS_SIGNALFD4   equ 289
SYS_EVENTFD2    equ 290
SYS_EPOLL_CREATE1   equ 291
SYS_DUP3    equ 292
SYS_PIPE2   equ 293
SYS_INOTIFY_INIT1   equ 294
SYS_PREADV  equ 295
SYS_PWRITEV equ 296
SYS_RT_TGSIGQUEUEINFO   equ 297
SYS_PERF_EVENT_OPEN equ 298
SYS_RECVMMSG    equ 299
SYS_FANOTIFY_INIT   equ 300
SYS_FANOTIFY_MARK   equ 301
SYS_PRLIMIT64   equ 302
SYS_NAME_TO_HANDLE_AT   equ 303
SYS_OPEN_BY_HANDLE_AT   equ 304
SYS_CLOCK_ADJTIME   equ 305
SYS_SYNCFS  equ 306
SYS_SENDMMSG    equ 307
SYS_SETNS   equ 308
SYS_GETCPU  equ 309
SYS_PROCESS_VM_READV    equ 310
SYS_PROCESS_VM_WRITEV   equ 311
SYS_KCMP    equ 312
SYS_FINIT_MODULE    equ 313
SYS_SCHED_SETATTR   equ 314
SYS_SCHED_GETATTR   equ 315
SYS_RENAMEAT2   equ 316
SYS_SECCOMP equ 317
SYS_GETRANDOM   equ 318
SYS_MEMFD_CREATE    equ 319
SYS_KEXEC_FILE_LOAD equ 320
SYS_BPF equ 321
STUB_EXECVEAT   equ 322
USERFAULTFD equ 323
MEMBARRIER  equ 324
MLOCK2  equ 325
COPY_FILE_RANGE equ 326
PREADV2 equ 327
PWRITEV2    equ 328


; =======================================================================================
; =============================           MACROS            =============================
; =======================================================================================


; ================================================================
; Wrapper for the SYS_READ
;
; PARAMETERS:
; 1 - File descriptor
; 2 - Container/array pointer
; 3 - Container/array size
;
%macro sys_read 3
    mov rax, SYS_READ
    mov rdi, %1  ; File descriptor
    mov rsi, %2  ; Container pointer
    mov rdx, %3  ; Container size
    syscall
%endmacro
;
; ================================================================


; ================================================================
; Wrapper for the SYS_WRITE
;
; PARAMETERS:
; 1 - File descriptor
; 2 - Content/array pointer
; 3 - Content/array size
;
%macro sys_write 3
    mov rax, SYS_WRITE
    mov rdi, %1  ; File descriptor
    mov rsi, %2  ; Content pointer
    mov rdx, %3  ; Content size
    syscall
%endmacro
;
; ================================================================


; ================================================================
; Wrapper for the SYS_OPEN
;
; OUTPUT: RAX as the File Descriptor
; PARAMETERS:
; 1 - Pointer to path
; 2 - Flag
; 3 - Mode
;
%macro sys_open 3
    mov rax, SYS_OPEN
    mov rdi, %1  ; Pointer to string that cointains the path
    mov rsi, %2  ; Flag (e.g.: O_RDONLY)
    mov rdx, %3  ; Mode (Permissions in XXXXo format)
    syscall
%endmacro
;
; ================================================================


; ================================================================
; Wrapper for the SYS_CLOSE
;
; PARAMETERS:
; 1 - File Descriptor
;
%macro sys_close 1
    mov rax, SYS_CLOSE
    mov rdi, %1  ; File Descriptor
    syscall
%endmacro
;
; ================================================================


; ================================================================
; Wrapper for the SYS_EXIT
;
; PARAMETERS:
; 1 - Exit code
;
%macro sys_exit 1
    mov rax, SYS_EXIT
    mov rdi, %1  ; Status code
    syscall
%endmacro
;
; ================================================================


%endif
