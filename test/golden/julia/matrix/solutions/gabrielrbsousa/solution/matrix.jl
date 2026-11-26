function matrix(strmatrix)
    # Your code here
    strmatrix = [parse.(Int, split(line," ")) for line in split(strmatrix, "\n") if !isempty(line)]
    rows = copy(strmatrix)
    columns = []
     # Check if rows are non-empty
    if !isempty(rows)
        # Loop over columns (assuming all rows have the same number of elements)
        for i in 1:length(rows[1])
            column = [row[i] for row in rows]  # Extract the i-th element from each row
            push!(columns, column)
        end
    end
    return rows, columns
end