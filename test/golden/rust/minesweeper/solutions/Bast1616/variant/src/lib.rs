pub fn annotate(minefield: &[&str]) -> Vec<String> {

    let mut OutVec = Vec::new();
    let mut rowString:String;
    let mut index_row = 0;
    let mut index_cell = 0;
    
    for row in minefield
    {
        rowString = String::new();
        index_cell = 0;
        for cell in row.chars()
        {
            if cell != '*'
            {
                rowString.push_str(&CountBomb(minefield,index_cell,index_row).to_owned());
            }
            else
            {
                rowString.push_str(&cell.to_string().to_owned());
            }
            
            index_cell+=1;
        }
        OutVec.push(rowString);
        index_row+=1;
    }
    OutVec
}

pub fn CountBomb(minefield: &[&str], x_pos:i32, y_pos:i32) -> String
{
    let mut index_row = 0;
    let mut index_cell = 0;
    let mut bomb_number = 0;
    
    for row in minefield {
        index_cell = 0;
        if index_row == y_pos - 1 || index_row == y_pos || index_row == y_pos +1
        {
            for cell in row.chars() 
            {
                if index_cell == x_pos - 1 || index_cell != x_pos || index_cell == x_pos +1
                {
                    if cell == '*'
                    {
                        bomb_number+=1;
                    }
                }
                index_cell+=1;
            }
        }
        index_row+=1;
    }
    if bomb_number == 0
    {
        return " ".to_string();
    }
    else
    {
        return bomb_number.to_string()
    }
    
}
    