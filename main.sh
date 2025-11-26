#!/bin/bash

DATA_DIR="data"
mkdir -p "$DATA_DIR"

echo "=== 가계부 설정 ==="
read -p "Month (MM): " MONTH
read -p "Day(DD): " DAY
read -p "월별 예상 예산: " EXPECTED
read -p "월별 목표 예산: " GOAL

FILE="$DATA_DIR/${MONTH}-${DAY}.txt"

{
    echo "EXPECTED:$EXPECTED"
    echo "GOAL:$GOAL"
} > "$FILE"

while true; do
    echo ""
    echo "1) 소비 지출 입력"
    echo "2) 통계 보기"
    echo "3) 종료"
    read -p "선택: " CH

     case $CH in
        1)
            echo ""
            echo "=== 지출 입력 (한 번에 입력) ==="
            read -p "식비 금액: " FOOD
            read -p "교통비 금액: " TRANSPORT
            read -p "쇼핑 금액: " SHOPPING
            read -p "기타 금액: " ETC

            DATE=$(date +%d)

            # 각각 기록
            echo "$DATE,식비,$FOOD" >> "$FILE"
            echo "$DATE,교통,$TRANSPORT" >> "$FILE"
            echo "$DATE,쇼핑,$SHOPPING" >> "$FILE"
            echo "$DATE,기타,$ETC" >> "$FILE"

            echo "모든 지출 등록됨!"
            ;;

        2)
            echo ""
            echo "==== 통계 ===="
            echo "월 예상 예산: $EXPECTED"
            echo "월 목표 예산: $GOAL"

            echo ""
            awk -F, '/^[0-9]/ {sum[$2]+=$3} END {
                for (c in sum)
                    print c":", sum[c]
            }' "$FILE"
            ;;

        3)
            echo "종료합니다."
            exit ;;
        *)
            echo "잘못된 선택"
            ;;
    esac
done
