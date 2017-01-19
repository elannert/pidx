#!/bin/bash
# use this once: git config credential.helper store
git add *
git commit -m "this stopped the [Amazon][RedShift ODBC] (30) Error occurred while trying to execute a query: ERROR: ORDER/GROUP BY expression not found in targetlist"
git push origin master