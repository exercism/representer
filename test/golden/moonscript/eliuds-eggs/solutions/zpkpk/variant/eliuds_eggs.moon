count_eggs = (num) ->
    cnt = 0
    while num > 0 do
        cnt += 1
        num = num & (num + 1)
    cnt
count_eggs