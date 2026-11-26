#!/usr/bin/env bash

# 1. 检查参数数量
[[ $# -ne 2 ]] && exit 1

# 2. 校验是否为合法列表格式（如果包含非数字、非逗号、非括号、非空格的字符，直接退出 1）
[[ "$1" =~ [^0-9,\[\]\ ] || "$2" =~ [^0-9,\[\]\ ] ]] && exit 1

# 3. 处理相等的情况
[ "$1" = "$2" ] && { echo "equal"; exit 0; }

# 4. 处理空列表的情况（注意：空列表 [] 不包含数字）
[[ "$1" = "[]" && "$2" == "[]" ]] && { echo "sublist"; exit 0; }
[[ "$2" = "[]" && "$1" != "[]" ]] && { echo "superlist"; exit 0; }

# 5. 提取纯数字内容用于比较
num1="${1//[\[\] ]/}"
num2="${2//[\[\] ]/}"

# 6. 长度比较与子列表查找
if (( ${#num1} > ${#num2} )); then
    # 如果 num1 更长，检查 num2 是否为 num1 的子列表 (即 num1 是 superlist)
    # 用 grep -F 固定字符串查找，避免正则特殊字符问题
    if [[ ",$num1," == *",$num2,"* ]]; then
        echo "superlist"
    else
        echo "unequal"
    fi
else
    # 如果 num2 更长，检查 num1 是否为 num2 的子列表 (即 num1 是 sublist)
    if [[ ",$num2," == *",$num1,"* ]]; then
        echo "sublist"
    else
        echo "unequal"
    fi
fi