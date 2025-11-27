#!/bin/bash

DATA_DIR="data"
read -p "분석할 달 (예: 2024-11): " month

FILE="${DATA_DIR}/${month}.txt"

if [ ! -f "$FILE" ]; then
    echo "❌ 해당 달의 데이터가 없습니다!"
    exit 1
fi

# 🔹 예상/목표 예산 불러오기
EXPECTED=$(grep "EXPECTED" "$FILE" | cut -d':' -f2)
GOAL=$(grep "GOAL" "$FILE" | cut -d':' -f2)

# 🔹 전체 지출 & 카테고리별 지출 계산
echo ""
echo "📊 === ${month} 소비 분석 ==="
echo "예상 예산: $EXPECTED"
echo "목표 예산: $GOAL"
echo ""

# 총합 계산
TOTAL=$(awk -F',' '/^[0-9]/ {sum+=$3} END {print sum}' "$FILE")

echo "총 지출: ${TOTAL}원"
echo ""

# 🔹 카테고리별 지출 + 비율 계산 + 그래프 출력
echo "📈 카테고리별 지출 비율 (ASCII 그래프)"
awk -F',' -v total="$TOTAL" '
/^[0-9]/ {cat[$2]+=$3}
END {
    for (c in cat) {
        percent = (cat[c] / total) * 100
        bar = ""
        for (i=0; i < percent/5; i++) bar = bar "■"  # 5%마다 블록 하나
        printf "• %-8s %8d원 (%.1f%%)  %s\n", c, cat[c], percent, bar
    }
}' "$FILE"
