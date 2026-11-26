hor = { '+': true, '-': true }
ver = { '+': true, '|': true }

{
  rectangles: (b) ->
    r = #b
    return 0 if r <= 1
    c = #b[1]
    return 0 if c <= 1
    get = (i, j) -> b[i]\sub j, j
    with res = 0
      for i0 = 1, r + 1
        for j0 = 1, c - 1
          top_left = get i0, j0
          continue unless top_left == '+'
          -- OK top-left corner

          for i1 = i0 + 1, r
            bot_left = get(i1, j0)
            continue if bot_left == '|'
            break unless bot_left == '+'
            -- OK bottom-left corner and left side

            for j1 = j0 + 1, c
              top_right = get(i0, j1)
              bot_right = get(i1, j1)
              break unless hor[top_right] and hor[bot_right]
              -- OK top and bottom lines -> all lines except right

              continue unless ver[top_right] and ver[bot_right]
              -- OK right corners -> all corners

              valid = true
              for i = i0 + 1, i1 - 1
                unless ver[get(i, j1)]
                  valid = false
                  break
              -- OK right side -> all sides -> valid rect.

              if valid
                res += 1
}
