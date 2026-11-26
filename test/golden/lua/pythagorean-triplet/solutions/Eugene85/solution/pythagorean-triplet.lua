return function(sum)
        local result = {}
        local ri = 1
        local cmin = math.ceil(sum/3)
        for c = cmin, sum-1 do            
            for a = 1, math.floor(sum/3) do
                local b = sum-c-a                
                if b>a and a*a + b*b == c*c then do
                        --print (a,b,c)
                        result[ri]={a,b,c}
                        ri = ri + 1
                    end
                end
            end        
      end
      return result
end