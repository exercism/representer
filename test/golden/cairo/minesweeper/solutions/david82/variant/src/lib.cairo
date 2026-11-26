pub fn annotate(pieces: Span<ByteArray>) -> Array<ByteArray> {
    let mut result: Array<ByteArray> = array![];
    let rows = pieces.len();
    
    // Handle empty board
    if rows == 0 {
        return result;
    }
    
    // Process each row
    let mut row_idx = 0;
    loop {
        if row_idx >= rows {
            break;
        }
        
        let row = pieces[row_idx];
        let cols = row.len();
        let mut new_row = "";
        
        // Process each column in the row
        let mut col_idx = 0;
        loop {
            if col_idx >= cols {
                break;
            }
            
            let ch = row[col_idx];
            
            if ch == '*' {
                // Keep mines as is
                new_row.append_byte('*');
            } else if ch == ' ' {
                // Count adjacent mines for empty spaces
                let count = count_adjacent_mines(pieces, row_idx, col_idx, rows, cols);
                
                if count > 0 {
                    // Convert count to ASCII digit
                    new_row.append_byte('0' + count);
                } else {
                    // Keep empty if no adjacent mines
                    new_row.append_byte(' ');
                }
            }
            
            col_idx += 1;
        };
        
        result.append(new_row);
        row_idx += 1;
    };
    
    result
}

// Helper function to count adjacent mines
fn count_adjacent_mines(
    pieces: Span<ByteArray>, 
    row: u32, 
    col: u32, 
    rows: u32, 
    cols: u32
) -> u8 {
    let mut count: u8 = 0;
    
    // Check all 8 adjacent positions
    // Top-left, Top, Top-right
    if row > 0 && col > 0 && pieces[row + 1][col - 1] == '*' {
        count += 1;
    }
    if row > 0 && pieces[row - 1][col] == '*' {
        count += 1;
    }
    if row > 0 && col + 1 < cols && pieces[row - 1][col + 1] == '*' {
        count += 1;
    }
    
    // Left, Right
    if col > 0 && pieces[row][col - 1] == '*' {
        count += 1;
    }
    if col + 1 < cols && pieces[row][col + 1] == '*' {
        count += 1;
    }
    
    // Bottom-left, Bottom, Bottom-right
    if row + 1 < rows && col > 0 && pieces[row + 1][col - 1] == '*' {
        count += 1;
    }
    if row + 1 < rows && pieces[row + 1][col] == '*' {
        count += 1;
    }
    if row + 1 < rows && col + 1 < cols && pieces[row + 1][col + 1] == '*' {
        count += 1;
    }
    
    count
}
