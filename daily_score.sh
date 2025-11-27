#!/bin/bash

# 폴더 & 날짜 기반 파일 경로 생성
DATA_DIR="data"
read -p "Year (YYYY): " YEAR
read -p "Month (MM): " MONTH
read -p "Day (DD): " DAY

MONTH_DIR="$DATA_DIR/${YEAR}-${MONTH}"
FILE="${MONTH_DIR}/${YEAR}-${MONTH}-${DAY}.txt"
MONTH_INFO="${MONTH_DIR}/month_info.txt"

# month_info에서 GOAL / EXPECTED 불러오기
if [ ! -f "$MONTH_INFO" ]; then
    echo "아직 month_info.txt가 없습니다! 먼저 main.sh에서 설정하세요."
    exit
fi

source "$MONTH_INFO"

# 오늘 사용금액 계산
TODAY_TOTAL=$(awk -F, '{sum+=$3} END {print sum}' "$FILE")

# 하루 목표 계산
DAILY_GOAL=$((GOAL / 30))

echo "📅 날짜: $YEAR-$MONTH-$DAY"
echo "💡 하루 목표 사용량: $DAILY_GOAL 원"
echo "🧾 오늘 사용 금액: $TODAY_TOTAL 원"

# 절약점수 계산 (100점 기준)
if [ "$TODAY_TOTAL" -le "$DAILY_GOAL" ]; then
    SCORE=$(( (DAILY_GOAL * 100) / TODAY_TOTAL ))
    echo "🟢 절약 점수: $SCORE 점 (잘했어요!)"
else
    SCORE=$(( (TODAY_TOTAL * 100) / DAILY_GOAL ))
    echo "🔴 절약 점수: $SCORE 점 (초과 소비!) 🚨"
fi

# 월 전체 소비 > EXPECTED 인지 확인
TOTAL_MONTH=$(awk -F, '{sum+=$3} END {print sum}' ${MONTH_DIR}/*.txt)

if [ "$TOTAL_MONTH" -gt "$EXPECTED" ]; then
    echo "🚨 경고: 월 예상 예산 ($EXPECTED원) 초과했습니다! 🚨"
fi
