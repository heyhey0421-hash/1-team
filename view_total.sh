#!/bin/bash

read -p "총합을 계산할 달을 입력하세요 (예: 2024-11): " month

if ! ls data/"$month"* &> /dev/null; then
    echo "⚠ 입력한 달의 데이터가 존재하지 않습니다."
    exit 1
fi

total=$(grep "$month" data/*.txt | awk '{sum += $3} END {print sum}')

echo "=============================="
echo "   📊  $month 소비 분석 결과"
echo "------------------------------"
echo "   ▶ 총 지출 금액 : ${total}원"
echo "=============================="
