#!/bin/bash

read -p "분석할 달 (예: 2024-11): " month

echo "📊 카테고리별 통계 ($month)"
grep "$month" data/*.txt | awk -F',' '{cat[$2]+=$3} END {for (c in cat) print "•", c, ":", cat[c] "원"}'
