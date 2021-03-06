/*-*- Mode: C; c-basic-offset: 8; indent-tabs-mode: nil -*-*/

/***
  This file is part of systemd.

  Copyright 2011 Lennart Poettering

  systemd is free software; you can redistribute it and/or modify it
  under the terms of the GNU Lesser General Public License as published by
  the Free Software Foundation; either version 2.1 of the License, or
  (at your option) any later version.

  systemd is distributed in the hope that it will be useful, but
  WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License
  along with systemd; If not, see <http://www.gnu.org/licenses/>.
***/

module deimos.systemd.sd_journal;

version(Posix){}
else
{
    static assert(false, "SystemD is only supported on Posix systems!");
}

import core.stdc.stdint;
import core.sys.posix.sys.types;
import core.stdc.stdarg;
import core.sys.posix.sys.uio;

//#include <syslog.h>

import deimos.systemd.sd_id128;

extern(C):

/* Journal APIs. See sd-journal(3) for more information. */

/* Write to daemon */
int sd_journal_print(int priority, const char *format, ...);
int sd_journal_printv(int priority, const char *format, va_list ap);
int sd_journal_send(const char *format, ...); //SENTINEL
int sd_journal_sendv(const iovec *iov, int n);
int sd_journal_perror(const char *message);

/+
/* Used by the macros below. Don't call this directly. */
int sd_journal_print_with_location(int priority, const char *file, const char *line, const char *func, const char *format, ...) __attribute__ ((format (printf, 5, 6)));
int sd_journal_printv_with_location(int priority, const char *file, const char *line, const char *func, const char *format, va_list ap);
int sd_journal_send_with_location(const char *file, const char *line, const char *func, const char *format, ...) __attribute__((sentinel));
int sd_journal_sendv_with_location(const char *file, const char *line, const char *func, const struct iovec *iov, int n);
int sd_journal_perror_with_location(const char *file, const char *line, const char *func, const char *message);

/* implicitly add code location to messages sent, if this is enabled */
#ifndef SD_JOURNAL_SUPPRESS_LOCATION

#define _sd_XSTRINGIFY(x) #x
#define _sd_STRINGIFY(x) _sd_XSTRINGIFY(x)

#define sd_journal_print(priority, ...) sd_journal_print_with_location(priority, "CODE_FILE=" __FILE__, "CODE_LINE=" _sd_STRINGIFY(__LINE__), __func__, __VA_ARGS__)
#define sd_journal_printv(priority, format, ap) sd_journal_printv_with_location(priority, "CODE_FILE=" __FILE__, "CODE_LINE=" _sd_STRINGIFY(__LINE__), __func__, format, ap)
#define sd_journal_send(...) sd_journal_send_with_location("CODE_FILE=" __FILE__, "CODE_LINE=" _sd_STRINGIFY(__LINE__), __func__, __VA_ARGS__)
#define sd_journal_sendv(iovec, n) sd_journal_sendv_with_location("CODE_FILE=" __FILE__, "CODE_LINE=" _sd_STRINGIFY(__LINE__), __func__, iovec, n)
#define sd_journal_perror(message) sd_journal_perror_with_location("CODE_FILE=" __FILE__, "CODE_LINE=" _sd_STRINGIFY(__LINE__), __func__, message)

#endif
+/

int sd_journal_stream_fd(const char *identifier, int priority, int level_prefix);

/* Browse journal stream */

struct sd_journal {};

enum {
        SD_JOURNAL_LOCAL_ONLY = 1,
        SD_JOURNAL_RUNTIME_ONLY = 2,
        SD_JOURNAL_SYSTEM_ONLY = 4
}

int sd_journal_open(sd_journal **ret, int flags);
int sd_journal_open_directory(sd_journal **ret, const char *path, int flags);
void sd_journal_close(sd_journal *j);

int sd_journal_previous(sd_journal *j);
int sd_journal_next(sd_journal *j);

int sd_journal_previous_skip(sd_journal *j, uint64_t skip);
int sd_journal_next_skip(sd_journal *j, uint64_t skip);

int sd_journal_get_realtime_usec(sd_journal *j, uint64_t *ret);
int sd_journal_get_monotonic_usec(sd_journal *j, uint64_t *ret, sd_id128_t *ret_boot_id);

int sd_journal_get_data(sd_journal *j, const char *field, const void **data, size_t *l);
int sd_journal_enumerate_data(sd_journal *j, const void **data, size_t *l);
void sd_journal_restart_data(sd_journal *j);

int sd_journal_add_match(sd_journal *j, const void *data, size_t size);
int sd_journal_add_disjunction(sd_journal *j);
void sd_journal_flush_matches(sd_journal *j);

int sd_journal_seek_head(sd_journal *j);
int sd_journal_seek_tail(sd_journal *j);
int sd_journal_seek_monotonic_usec(sd_journal *j, sd_id128_t boot_id, uint64_t usec);
int sd_journal_seek_realtime_usec(sd_journal *j, uint64_t usec);
int sd_journal_seek_cursor(sd_journal *j, const char *cursor);

int sd_journal_get_cursor(sd_journal *j, char **cursor);

int sd_journal_get_cutoff_realtime_usec(sd_journal *j, uint64_t *from, uint64_t *to);
int sd_journal_get_cutoff_monotonic_usec(sd_journal *j, const sd_id128_t boot_id, uint64_t *from, uint64_t *to);

/* int sd_journal_query_unique(sd_journal *j, const char *field);      /\* missing *\/ */
/* int sd_journal_enumerate_unique(sd_journal *j, const void **data, size_t *l); /\* missing *\/ */
/* void sd_journal_restart_unique(sd_journal *j);                      /\* missing *\/ */

enum {
        SD_JOURNAL_NOP,
        SD_JOURNAL_APPEND,
        SD_JOURNAL_INVALIDATE
}

int sd_journal_get_fd(sd_journal *j);
int sd_journal_process(sd_journal *j);
int sd_journal_wait(sd_journal *j, uint64_t timeout_usec);
/+
#define SD_JOURNAL_FOREACH(j)                                           \
        if (sd_journal_seek_head(j) >= 0)                               \
                while (sd_journal_next(j) > 0)

#define SD_JOURNAL_FOREACH_BACKWARDS(j)                                 \
        if (sd_journal_seek_tail(j) >= 0)                               \
                while (sd_journal_previous(j) > 0)

#define SD_JOURNAL_FOREACH_DATA(j, data, l)                             \
        for (sd_journal_restart_data(j); sd_journal_enumerate_data((j), &(data), &(l)) > 0; )

/* #define SD_JOURNAL_FOREACH_UNIQUE(j, data, l)                           \ */
/*         for (sd_journal_restart_unique(j); sd_journal_enumerate_data((j), &(data), &(l)) > 0; ) */
+/
