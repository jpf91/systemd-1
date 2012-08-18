/*-*- Mode: C; c-basic-offset: 8; indent-tabs-mode: nil -*-*/

/***
  This file is part of systemd.

  Copyright 2012 Lennart Poettering

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

module deimos.systemd.sd_messages;

version(Posix){}
else
{
    static assert(false, "SystemD is only supported on Posix systems!");
}
import deimos.systemd.sd_id128;

extern(C):

enum SD_MESSAGE_JOURNAL_START =  SD_ID128_MAKE(0xf7,0x73,0x79,0xa8,0x49,0x0b,0x40,0x8b,0xbe,0x5f,0x69,0x40,0x50,0x5a,0x77,0x7b);
enum SD_MESSAGE_JOURNAL_STOP  =  SD_ID128_MAKE(0xd9,0x3f,0xb3,0xc9,0xc2,0x4d,0x45,0x1a,0x97,0xce,0xa6,0x15,0xce,0x59,0xc0,0x0b);
enum SD_MESSAGE_JOURNAL_DROPPED = SD_ID128_MAKE(0xa5,0x96,0xd6,0xfe,0x7b,0xfa,0x49,0x94,0x82,0x8e,0x72,0x30,0x9e,0x95,0xd6,0x1e);

enum SD_MESSAGE_COREDUMP      =  SD_ID128_MAKE(0xfc,0x2e,0x22,0xbc,0x6e,0xe6,0x47,0xb6,0xb9,0x07,0x29,0xab,0x34,0xa2,0x50,0xb1);
