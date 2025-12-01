#!/bin/bash

DATA_DIR="data"
BACKUP_DIR="backup"

mkdir -p "$DATA_DIR"
mkdir -p "$BACKUP_DIR"

echo "=== 가계부 설정 ==="
read -p "Year (YYYY): " YEAR
read -p "Month (MM): " MONTH
read -p "Day (DD): " DAY

# -----------------------------
# 1) 월별 폴더 자동 생성
# -----------------------------
MONTH_DIR="$DATA_DIR/${YEAR}-${MONTH}"
mkdir -p "$MONTH_DIR"

# -----------------------------
# 2) 월 예산 파일 생성
# -----------------------------
MONTH_INFO="${MONTH_DIR}/month_info.txt"

if [ ! -f "$MONTH_INFO" ]; then
    echo "이번 달은 처음 사용합니다!"
    read -p "월별 예상 예산: " EXPECTED
    read -p "월별 목표 예산: " GOAL

    {
        echo "EXPECTED=$EXPECTED"
        echo "GOAL=$GOAL"
    } > "$MONTH_INFO"
else
    source "$MONTH_INFO"
fi

# -----------------------------
# 3) 날짜별 지출 파일
# -----------------------------
FILE="${MONTH_DIR}/${YEAR}-${MONTH}-${DAY}.txt"
touch "$FILE"

# -----------------------------
# 4) 자동 백업 함수
# -----------------------------
backup_file() {
    BAK_MONTH_DIR="$BACKUP_DIR/${YEAR}-${MONTH}"
    mkdir -p "$BAK_MONTH_DIR"
    cp "$FILE" "${BAK_MONTH_DIR}/${YEAR}-${MONTH}-${DAY}.txt.bak"
}

backup_file   # 초기 파일 백업

# -----------------------------
# 5) 메인 메뉴 시작
# -----------------------------
while true; do
    echo ""
    echo "========= 메인 메뉴 ========="
    echo "1) 소비 지출 입력"
    echo "2) 통계 보기"
    echo "3) 종료"
    echo "============================="
    read -p "번호 선택: " CH

    case $CH in
        1)
            echo ""
            echo "=== 지출 입력 ==="
            read -p "식비 금액: " FOOD
            read -p "교통비 금액: " TRANSPORT
            read -p "쇼핑 금액: " SHOPPING
            read -p "기타 금액: " ETC

            TODAY="${YEAR}-${MONTH}-${DAY}"

            echo "$TODAY,식비,$FOOD" >> "$FILE"
            echo "$TODAY,교통,$TRANSPORT" >> "$FILE"
            echo "$TODAY,쇼핑,$SHOPPING" >> "$FILE"
            echo "$TODAY,기타,$ETC" >> "$FILE"

            backup_file
            echo "모든 지출 등록됨!"
            ;;
        
        2)
            # 📌 세부 통계 선택 메뉴
            while true; do
                echo ""
                echo "📊 === 통계 메뉴 ==="
                echo "1) 월 총합 보기    "
                echo "2) 카테고리별 합계 "
                echo "3) 소비 그래프 보기 "
                echo "4) 절약 점수 확인 "
                echo "5) 뒤로가기"
                echo "========================"
                read -p "번호 선택: " SUB

                case $SUB in
                    1) ./view_total.sh ;;
                    2) ./view_category.sh ;;
                    3) ./view_graph.sh ;;
                    4) ./daily_score.sh ;;
                    5) break ;;     # 메인 메뉴로 돌아가기
                    *) echo "잘못된 입력입니다." ;;
                esac
            done
            ;;

        3)
            echo "프로그램을 종료합니다."
            exit ;;

        *)
            echo "잘못된 선택입니다."
            ;;
    esac
done
