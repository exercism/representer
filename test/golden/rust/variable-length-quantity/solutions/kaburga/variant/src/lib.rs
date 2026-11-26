//use std::fmt::Error as OtherError;

#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    IncompleteNumber,
    Overflow,
}

/// Convert a list of numbers to a stream of bytes encoded with variable length encoding.
pub fn to_bytes(values: &[u32]) -> Vec<u8> {
    let mut bytes = Vec::<u8>::new();
    for value in values {
        bytes.append(&mut encode(value));
    }
    bytes
}

fn encode(value: &u32) -> Vec<u8> {
    let mut bytes = Vec::<u8>::new();
    let mut value = *value;

    let mut encoded_byte = (value & 0x7f) as u8;
    bytes.push(encoded_byte);
    value = value >> 7;
    while value > 0 {
        encoded_byte = ((value & 0x7f) | 0x80) as u8;
        bytes.push(encoded_byte);
        value = value >> 7;
    }

    bytes.reverse();
    bytes
}

/// Given a stream of bytes, extract all numbers which are encoded in there.
pub fn from_bytes(bytes: &[u8]) -> Result<Vec<u32>, Error> {
    let mut values = Vec::<u32>::new();
    let mut value: u32 = 0;
    let mut complete: bool = false;

    for byte in bytes {
        if value > 0x0200_0000 {
            return Err(Error::Overflow);
        }
        complete = false;
        value = (value << 7) + (byte & 0x7f) as u32;
        if byte & 0x80 == 0 {
            values.push(value);
            value = 0;
            complete = true;
        }
    }

    if !complete {
        return Err(Error::IncompleteNumber);
    }
    Ok(values)
}
