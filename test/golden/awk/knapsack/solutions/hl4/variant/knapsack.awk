function max(a,b) { return a > b ? a : b }

match($0, /limit:([0-9]+)/, data) {
    limit = data[1]
    for(i = 0; i <= limit; i++) {
        dp[i] = 0
    }
}
match($0, /weight:([0-9]+),value:([0-9]+)/, data){
    w = data[1]
    v = data[2]
    for(i = limit; i >= w; i--) {
        dp[i] = max(dp[i-w] + v, dp[i])
    }
}
END {
    answer = 0
    for(i = 0; i < limit; i++) {
        answer = max(answer, dp[i])
    }
    print answer
}