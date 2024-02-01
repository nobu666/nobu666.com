#!/bin/bash
new_seq=$(( $(basename $(find content -type f -name '*.md' | awk -F/ '{print $6}' | sort -nr | head -n1) .md) + 1 ))
hugo new $(date +%Y/%m/%d)/${new_seq}.md | awk -F\" '{print $2}' | xsel --clipboard --input
