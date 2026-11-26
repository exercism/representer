return {
  measure = function(args)
      local one = args.bucket_one_capacity
      local two = args.bucket_two_capacity
      local goal = args.goal_volume
      local start = args.start_bucket
        
      assert(goal <= one or goal <= two)
      local ignore = {
          ['0:0'] = 0,
          [one .. ':0'] = 0,
          ['0:' .. two] = 0
      }
      local function figure(a, b, turn)
          local key = a .. ':' .. b
        
          if turn > 1 then
            if ignore[key] then
                if ignore[key] <= turn then
                    return nil
                end
            end
          end
      
          ignore[key] = turn
          
          if a == goal then
              return {moves = turn, goal_bucket_number = 1, other_bucket_volume = b}
          elseif b == goal then
              return {moves = turn, goal_bucket_number = 2, other_bucket_volume = a}
          end

          local results = {}
          table.insert(results, figure(0, b, turn + 1))
          table.insert(results, figure(a, 0, turn + 1))
          table.insert(results, figure(one, b, turn + 1))
          table.insert(results, figure(a, two, turn + 1))
        
          local diff
        
          if a <= one and b > 0 then
              diff = one - a
              if b >= diff then
                  table.insert(results, figure(one, b - diff, turn + 1))
              else
                  table.insert(results, figure(a + b, 0, turn + 1))
              end
          end
      
          if b < two and a > 0 then
              diff = two - b
              if a >= diff then
                  table.insert(results, figure(a - diff, two, turn + 1))
              else
                  table.insert(results, figure(0, a + b, turn + 1))
              end
          end

          for i = #results, 1, -1 do
              if not results[i] then
                  table.remove(results, i)
              end
          end

          if #results < 1 then return nil end

          table.sort(results, function(rea, reb) return rea.moves < reb.moves end)

          return results[1]
      end

      local result = figure((2 - start) * one, (start - 1) * two, 1)
      assert(result)
      return result
  end
}
