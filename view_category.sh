#!/bin/bash

DATA_DIR="data"
read -p "분석할 달 (예: 2024-11): " month

FILE="${DATA_DIR}/${month}.txt"

if [ ! -f "$FILE" ]; then
    echo "❌ 해당 달의 데이터가 없습니다!"
    exit 1
fi

# 🔥 카테고리별 통계 (한 줄짜리 버전)
echo "📊 카테고리별 통계 ($month)"
awk -F',' '/^[0-9]/ {cat[$2]+=$3} END {for (c in cat) print "•", c, ":", cat[c] "원"}' "$FILE"
