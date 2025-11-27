#!/bin/bash

# 📌 1. 데이터 폴더

DATA_DIR="data"

# 📌 2. 월 입력받기

read -p "분석할 달을 입력하세요 (예: 2025-12): " month

# 📌 3. 월 데이터 확인

if ! ls "$DATA_DIR/$month"/*.txt >/dev/null 2>&1; then
echo "❌ 해당 월의 데이터가 없습니다!"
exit 1
fi

# 📌 4. 예상 예산 / 목표 예산 불러오기

MONTH_INFO="$DATA_DIR/$month/month_info.txt"
EXPECTED=$(grep "EXPECTED=" "$MONTH_INFO" | cut -d'=' -f2)
GOAL=$(grep "GOAL=" "$MONTH_INFO" | cut -d'=' -f2)

# ================================

# 📌 5. 분석 결과 출력

# ================================

echo ""
echo "📆 ${month} 소비 분석"
echo "━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧾 총 예상 예산: $EXPECTED 원"
echo "💰 목표 예산: $GOAL 원"
echo ""

# ================================

# 📌 6. 총 지출 금액 계산

# ================================

total=$(awk -F',' '{sum+=$3} END {print sum}' "$DATA_DIR/$month"/*.txt)
echo "💸 총 지출 금액: $total 원"
echo "━━━━━━━━━━━━━━━━━━━━━━━"

# ================================

# 📌 7. 카테고리별 통계 계산

# ================================

echo "📊 카테고리별 지출"
awk -F',' '
/^[0-9]/ { sum[$2]+=$3 }
END {
for (c in sum) {
printf "  - %-8s : %d원\n", c, sum[c];
}
}' "$DATA_DIR/$month"/*.txt
echo "━━━━━━━━━━━━━━━━━━━━━━━"

# ================================

# 📌 8. 그래프 추가 (ASCII BAR 그래프)

# ================================

echo ""
echo "📈 소비 그래프 (ASCII)"
echo "────────────────────────"

awk -F',' '
/^[0-9]/ {
sum[$2] += $3;   # 카테고리별 합계
}
END {
print "📊 카테고리별 사용량 그래프"
for (c in sum) {
bar = "";
value = int(sum[c] / 5000);     # 💰 5000원당 █ 1개
for (i = 0; i < value; i++) bar = bar "█";
printf "%-8s | %-30s %d원\n", c, bar, sum[c];
}
}' "$DATA_DIR/$month"/*.txt

echo "────────────────────────"
echo "그래프는 1칸 = 5000원 입니다"
