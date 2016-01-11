#!/bin/bash
new_seq=$(( $(basename $(find content -type f -name '*.md' | awk -F/ '{print $5}' | sort -nr | head -n1) .md) + 1 ))
hugo new $(date +%Y/%m/%d)/${new_seq}.md | awk '{print $1}' | pbcopy
