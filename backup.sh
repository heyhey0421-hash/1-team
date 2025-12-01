# -----------------------------
# 4) 자동 백업 함수
# -----------------------------
backup_file() {
    BAK_MONTH_DIR="$BACKUP_DIR/${YEAR}-${MONTH}"
    mkdir -p "$BAK_MONTH_DIR"

    # 타임스탬프 생성 (YYYYMMDD-HHMMSS)
    TIMESTAMP=$(date +"%Y%m%d-%H%M%S")

    # 원본 파일이 존재하는지 확인
    if [ ! -f "$FILE" ]; then
        echo "[백업 실패] 원본 파일이 없습니다: $FILE"
        return
    fi

    # 백업 파일명: YYYY-MM-DD.txt.bak_타임스탬프
    BAK_FILE="${BAK_MONTH_DIR}/${YEAR}-${MONTH}-${DAY}.txt.bak_${TIMESTAMP}"

    cp "$FILE" "$BAK_FILE"
    echo "[백업 완료] -> $BAK_FILE"
}
