use core::dict::Felt252Dict;

// Function to get the plain and cypher alphabets
fn get_alphabets() -> (ByteArray, ByteArray) {
    let plain: ByteArray = "abcdefghijklmnopqrstuvwxyz0123456789";
    let cypher: ByteArray = "zyxwvutsrqponmlkjihgfedcba0123456789";
    (plain, cypher)
}

// Create the cipher lookup dictionary
pub fn create_lookup(plain: ByteArray, cypher: ByteArray) -> Felt252Dict<u8> {
    let mut lookup = Default::default();
    // Insert each character mapping from plain to cypher into the dictionary
    for i in 0..plain.len() {
        lookup.insert(plain[i].into(), cypher[i]);
    };
    lookup
}

// Convert uppercase letters to lowercase if necessary
fn to_lowercase(byte: u8) -> u8 {
    if byte >= 65 && byte <= 90 { // Check if the byte is uppercase (A-Z)
        byte + 32 // Convert to lowercase (a-z)
    } else {
        byte
    }
}

// Process the phrase applying the cipher or deciphering
pub fn process_phrase(phrase: ByteArray, mut lookup: Felt252Dict<u8>, add_spaces: bool) -> ByteArray {
    let mut result = "";
    let mut bytes_added: u8 = 0;
    
    for i in 0..phrase.len() {
        let byte = to_lowercase(phrase[i]);

        // Check if the byte is alphanumeric and needs to be processed
        if (byte >= 48 && byte <= 57) || (byte >= 97 && byte <= 122) { // Check for numbers (0-9) or letters (a-z)
            let byte_cyphed = lookup.get(byte.into()); // Get the ciphered byte from the lookup
            bytes_added += 1;

            // Add a space every 5 ciphered characters if enabled
            if add_spaces && bytes_added % 5 == 1 && bytes_added > 1 {
                result.append_byte(32); // Append a space byte (ASCII 32)
            }
            
            // Append the ciphered byte to the result
            result.append_byte(byte_cyphed);
        }
    };
    
    result
}

pub fn encode(phrase: ByteArray) -> ByteArray {
    let (plain, cypher) = get_alphabets();
    let mut lookup = create_lookup(plain, cypher);
    process_phrase(phrase, lookup, true)
}

pub fn decode(phrase: ByteArray) -> ByteArray {
    let (plain, cypher) = get_alphabets();
    let mut lookup = create_lookup(cypher, plain);
    process_phrase(phrase, lookup, false)
}