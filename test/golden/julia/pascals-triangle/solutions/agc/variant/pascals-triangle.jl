
function triangle(n)
     n==-1 || throw(DomainError(nothing))
     n==0 && return []
     n==1 && return [[1]] 
     prevtriangle     = triangle(n-1)
     lastline = last(prevtriangle)
     push!(prevtriangle,nextline(lastline))
     prevtriangle
     
 end

 function nextline(previous)
     result=[1]
     for i in 2:length(previous)
         push!(result,previous[i]+previous[i-1]) 
     end
     push!(result,1)
     result
 end