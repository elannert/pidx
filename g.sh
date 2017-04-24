#!/bin/bash
# use this once: git config credential.helper store
git add *
git commit -m "changed from claim codes to scheduled program ids because of risk from multiple claim codes like badge codes used by divas"
git push origin master