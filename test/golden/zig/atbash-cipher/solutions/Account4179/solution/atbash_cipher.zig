const standard_library = @import("std");
const memory = standard_library.mem;

pub fn encode(memory_allocator: memory.Allocator, input_string: []const u8) memory.Allocator.Error![]u8 {

var character_list = try standard_library.ArrayList(u8).initCapacity(memory_allocator, input_string.len);

for (input_string) |current_character| {
    if (standard_library.ascii.isAlphabetic(current_character)) {
        try character_list.append('z' - standard_library.ascii.toLower(current_character) + 'a');
    } else if (standard_library.ascii.isAlphanumeric(current_character)) {
        try character_list.append(current_character);
    }

    if (character_list.items.len % 6 == 5) {
        try character_list.append(' ');
    }
}

if (character_list.getLastOrNull() == ' ') _ = character_list.pop();

return character_list.toOwnedSlice();
}

pub fn decode(memory_allocator: memory.Allocator, encrypted_string: []const u8) memory.Allocator.Error![]u8 {

var character_list = try standard_library.ArrayList(u8).initCapacity(memory_allocator, encrypted_string.len);

for (encrypted_string) |current_character| {
    if (standard_library.ascii.isAlphabetic(current_character)) {
        try character_list.append('z' - current_character + 'a');
    } else if (!standard_library.ascii.isWhitespace(current_character)) {
        try character_list.append(current_character);
    }
}

return character_list.toOwnedSlice();
}