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

module deimos.systemd.sd_id128;

version(Posix){}
else
{
    static assert(false, "SystemD is only supported on Posix systems!");
}

import core.stdc.stdint;
import core.stdc.string;

/* 128 Bit ID APIs. See sd-id128(3) for more information. */

union sd_id128_t {
        uint8_t bytes[16];
        uint64_t qwords[2];
};

extern(C):

char *sd_id128_to_string(sd_id128_t id, char[33] s);

int sd_id128_from_string(const char[33] s, sd_id128_t *ret);

int sd_id128_randomize(sd_id128_t *ret);

int sd_id128_get_machine(sd_id128_t *ret);

int sd_id128_get_boot(sd_id128_t *ret);


sd_id128_t SD_ID128_MAKE()(ubyte v0,ubyte v1,ubyte v2,ubyte v3,ubyte v4,ubyte v5,ubyte v6,ubyte v7,ubyte v8,ubyte v9,ubyte v10,ubyte v11,ubyte v12,ubyte v13,ubyte v14,ubyte v15)
{
    sd_id128_t val;
    val.bytes[0] = v0;
    val.bytes[1] = v1;
    val.bytes[2] = v2;
    val.bytes[3] = v3;
    val.bytes[4] = v4;
    val.bytes[5] = v5;
    val.bytes[6] = v6;
    val.bytes[7] = v7;
    val.bytes[8] = v8;
    val.bytes[9] = v9;
    val.bytes[10] = v10;
    val.bytes[11] = v11;
    val.bytes[12] = v12;
    val.bytes[13] = v13;
    val.bytes[14] = v14;
    val.bytes[15] = v15;
    return val;
}

/* Note that SD_ID128_FORMAT_VAL will evaluate the passed argument 16
 * times. It is hence not a good idea to call this macro with an
 * expensive function as paramater or an expression with side
 * effects */
//enum SD_ID128_FORMAT_STR "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x";
//#define SD_ID128_FORMAT_VAL(x) (x).bytes[0], (x).bytes[1], (x).bytes[2], (x).bytes[3], (x).bytes[4], (x).bytes[5], (x).bytes[6], (x).bytes[7], (x).bytes[8], (x).bytes[9], (x).bytes[10], (x).bytes[11], (x).bytes[12], (x).bytes[13], (x).bytes[14], (x).bytes[15]

extern(D) bool sd_id128_equal(sd_id128_t a, sd_id128_t b)
{
        return memcmp(&a, &b, 16) == 0;
}
