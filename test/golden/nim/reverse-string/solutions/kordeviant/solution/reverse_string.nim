proc reverse(st: string) : string =
    result = newString(st.len)
    for s in countdown(st.len, 1) :
        result[st.len - s] = st[s - 1]
export reverse