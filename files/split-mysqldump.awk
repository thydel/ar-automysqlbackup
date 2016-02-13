#!/usr/bin/gawk -f

BEGIN {
    bmatch = "^-- Current Database: `(.*)`$"
    tmatch = "^-- Table structure for table `(.*)`$"
}

function out() { return txt || sql ? cat() : gzip() }

match($0, bmatch, t) { base = t[1]; system("mkdir -p " base) }
match($0, tmatch, t) {
    if (table) close(out())
    table = t[1]
    printf head | out()
}

!table { head = head $0 RS }
 table { print | out() }

function name() { return base "/" table ".sql" }
function cat()  { return "cat  > " name() }
function gzip() { return "gzip > " name() ".gz" }
