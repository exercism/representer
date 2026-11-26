use core::dict::Felt252Dict;

pub fn commands(number: u8) -> Array<ByteArray> {
    let mut binary: ByteArray = Default::default();
    let mut quotient = number;
    let mut new_output_array =ArrayTrait::new();
    while quotient != 0 {
        let remainder: u8 = quotient % 2;
        quotient = quotient /2;
        binary.append_word(remainder.into(), 1);
        new_output_array.append(remainder);
    };

    let action_res = action(new_output_array.clone());
    return action_res;
}

fn action(mut binary: Array<u8>) -> Array<ByteArray> {
    let mut actions: Felt252Dict<felt252> = Default::default();
    actions.insert(0, 'wink');
    actions.insert(1, 'double blink');
    actions.insert(2, 'close your eyes');
    actions.insert(3, 'jump');

    let mut actions_len: Felt252Dict<u32> = Default::default();
    actions_len.insert(0, 4);
    actions_len.insert(1, 12);
    actions_len.insert(2, 15);
    actions_len.insert(3, 4);

    let mut output_array =ArrayTrait::<ByteArray>::new();
    let mut binary_array =ArrayTrait::<u8>::new();
    let mut len = binary.len();
    let mut reverse = false;

    let mut index = 0;
    loop {
        if (index == len)  {
            break;
        };
        let val = binary.at(len - index -1);
        binary_array.append(*val);
        index += 1;
    };

    if len == 5 {
        let _ = binary_array.pop_front().unwrap();
        reverse = true;
    }

    len = binary_array.len();
    let mut index = 0;
    loop {
        if index == len{
            break;
        }
        let mut output: ByteArray = Default::default();

        if reverse == true {
            let chr = *binary_array.at(index);
            if chr == 1_u8 {
                let action = actions.get((len - index -1).into());
                output.append_word(action.into(), actions_len.get((len - index -1).into()));
                output_array.append(output);
            }
        } else  {
            let chr = *binary_array.at(len-index-1);
            if chr == 1_u8 {
                let action = actions.get(index.into());
                output.append_word(action.into(), actions_len.get(index.into()));
                output_array.append(output);
            }
        }  
        index += 1;
    };
    output_array
}