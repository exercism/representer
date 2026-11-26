function saddlepoints(M)
    saddle_points = []
    for i in 1:size(M, 1)
        for j in 1:size(M, 2)
            if M[i, j] == maximum(M[i, :]) && M[i, j] == minimum(M[:, j])
                push!(saddle_points, (i, j))
            end
        end
    end
    saddle_points
end
