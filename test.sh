#!/bin/sh
R -q -e 'options(error = NULL); devtools::test(f = "filter-dm", reporter = "fail")'
