function binarysearch(array,element; by::Function=identity,rev::Bool=false)
array = by.(array); element = by(element)
la=length(array)
iseven(la) ? step = Int(la/2) : step = Int((la+1)/2)
i = step
ii = 1
ie = la
while  step >= 1
	if array[i] == element
		return i:i
	elseif (array[i] < element && !rev) || (array[i] > element && rev)
		ii = i+1
		brray = array[ii:ie]
		lb = length(brray)
		lb == 1 && (array[ii] == element ? (return ii:ii) : (return 1:0))
		iseven(lb) ? step = Int(lb/2) : step = Int((lb+1)/2)
		i += step
	elseif (array[i] > element && !rev) || (array[i] < element && rev)
		ie = i-1
		brray = array[ii:ie]
		lb = length(brray)
		lb == 1 && (array[ii] == element ? (return ii:ii) : (return 1:0))
		println(i,"\t",lb)	
		iseven(lb) ? step = Int(lb/2) : step = Int((lb+1)/2)
		i = i-step	
	end
end
return 1:0
end	
