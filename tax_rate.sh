#!/bin/bash

read -p "What is your monthly income (TL): " tl
tl=$(echo $tl | tr -d '\n')
value=$(echo $tl | tr -d '\n' | sed 's/[^0-9]*//g')

taxMoney=$((value * 12))
totalEarned=$((value * 12))
totalTax=0

if ! [[ $value =~ ^[0-9]+$ ]]; then
    echo "Invalid input"
    exit 1
fi

read -p "Are you younger than 29? (Y/N): " age
age=$(echo $age | tr -d '\n' | tr '[:upper:]' '[:lower:]')
if [ "$age" != "y" ] && [ "$age" != "n" ]; then
    echo "Invalid option provided"
    exit 1
fi

if [ "$age" == "y" ]; then
    taxMoney=$((taxMoney - 150000))
fi

read -p "What will be your monthly expense (tl): " monthly
monthly=$(echo $monthly | tr -d '\n')

intMonthly=$(echo $monthly | tr -d '\n' | sed 's/[^0-9]*//g')

taxMoney=$((taxMoney - 12 * intMonthly))
taxMoney=$((taxMoney / 5))

if [ $taxMoney -le 70000 ]; then
    totalTax=$((taxMoney * 15 / 100))
elif [ $taxMoney -gt 70000 ] && [ $taxMoney -le 150000 ]; then
    totalTax=$((($taxMoney - 70000) * 20 / 100 + 10500))
elif [ $taxMoney -gt 150000 ] && [ $taxMoney -le 550000 ]; then
    totalTax=$((($taxMoney - 150000) * 27 / 100 + 26500))
elif [ $taxMoney -gt 550000 ] && [ $taxMoney -le 1900000 ]; then
    totalTax=$((($taxMoney - 550000) * 35 / 100 + 134500))
else
    totalTax=$((($taxMoney - 1900000) * 40 / 100 + 607000))
fi

echo "what you earn is $totalEarned"
echo "you will pay tax on $taxMoney"
echo "what is your tax per year $totalTax"
echo "your net profit is $((totalEarned - totalTax))"
echo "your monthly earning is $(((totalEarned - totalTax) / 12))"
echo "your tax rate is $(echo "scale=2; 100 * $totalTax / $totalEarned" | bc)%"