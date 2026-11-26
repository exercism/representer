{
  canChain: (dominoes) ->
    return true if #dominoes == 0
    -- disjoint-set union (DSU)
    dsu = {}
    find_root = (x) ->
      if dsu[x] == x
        x
      else
        y = find_root dsu[x]
        dsu[x] = y
        y
    union = (x, y) ->
      x = find_root x
      y = find_root y
      if x != y
        dsu[y] = x
    -- process dominoes
    degs = {}
    for {x, y} in *dominoes
      for z in *{x, y}
        if not degs[z]
          -- initialize on-the-fly
          degs[z], dsu[z] = 0, z
        degs[z] += 1
      union x, y
    -- check if (1) all degrees are even and (2) the graph is connected
    z = nil
    for x, d in pairs degs
      y = find_root x
      z = z or y
      return false if z != y and d % 2 != 0
    true
}
