#!/bin/bash

DATA_DIR="data"
read -p "분석할 달 (예: 2024-11): " month

FILES="$DATA_DIR/$month/*.txt"

# 📌 해당 달 데이터 확인
if ! ls $FILES >/dev/null 2>&1; then
    echo "❌ 해당 달의 데이터가 없습니다!"
    exit 1
fi

# 📌 예상 / 목표 불러오기
EXPECTED=$(grep "EXPECTED" "$DATA_DIR/$month/month_info.txt" | cut -d'=' -f2)
GOAL=$(grep "GOAL" "$DATA_DIR/$month/month_info.txt" | cut -d'=' -f2)

echo "📊 === ${month} 소비 분석 ==="
echo "💡 예상 예산 : $EXPECTED"
echo "🎯 목표 예산 : $GOAL"
echo ""

# 📈 전체 지출 + 카테고리별 지출 계산
awk -F',' '/^[0-9]/ {
    sum[$2] += $3     # 카테고리별 합
    total   += $3     # 전체 지출
} END {
    print "=============================="
    print "📦 총 지출 금액:", total "원"
    print "\n----- 카테고리별 지출 -----"
    for (c in sum) {
        printf "• %s : %d원\n", c, sum[c]
    }
    print "=============================="
}' $FILES    # ← 여기!! $FILES 꼭 넣어야 함!!
