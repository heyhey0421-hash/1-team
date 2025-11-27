#!/bin/bash

# ⭐ main.sh 에서 날짜 받아오기
YEAR=$1
MONTH=$2
DAY=$3

DATA_DIR="data"
MONTH_DIR="$DATA_DIR/${YEAR}-${MONTH}"
FILE="${MONTH_DIR}/${YEAR}-${MONTH}-${DAY}.txt"
MONTH_INFO="${MONTH_DIR}/month_info.txt"

# month_info 가 없으면 종료
if [ ! -f "$MONTH_INFO" ]; then
    echo "⚠️ 아직 month_info.txt가 없습니다! 먼저 main.sh에서 설정하세요."
    exit
fi

# 예상/목표 예산 불러오기
source "$MONTH_INFO"

# 오늘 사용 금액 계산
TODAY_TOTAL=$(awk -F, '{sum+=$3} END {print sum}' "$FILE")

# 하루 목표 계산
DAILY_GOAL=$((GOAL / 30))

echo "📅 날짜: $YEAR-$MONTH-$DAY"
echo "💡 하루 목표 사용량: $DAILY_GOAL 원"
echo "🧾 오늘 사용 금액: $TODAY_TOTAL 원"

# 절약 점수 계산 (0~200점 가능)
if [ "$TODAY_TOTAL" -le "$DAILY_GOAL" ]; then
    SCORE=$(( (TODAY_TOTAL * 100) / DAILY_GOAL ))
    SCORE=$((100 + (100 - SCORE)))    # 절약 → 100점 + 추가점수
    echo "🟢 절약 점수: $SCORE 점  (잘했어요!)"
else
    SCORE=$(( (DAILY_GOAL * 100) / TODAY_TOTAL ))
    echo "🔴 절약 점수: $SCORE 점  (초과 소비!) 🚨"
fi

# 월 전체 소비 > 예상 예산이면 경고
TOTAL_MONTH=$(awk -F, '{sum+=$3} END {print sum}' ${MONTH_DIR}/*.txt)
if [ "$TOTAL_MONTH" -gt "$EXPECTED" ]; then
    echo "🚨 경고: 월 예상 예산 ($EXPECTED원) 초과했습니다! 🚨"
fi
