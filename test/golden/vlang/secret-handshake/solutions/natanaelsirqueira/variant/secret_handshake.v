module main

enum Command as u8 {
	wink
	double_blink
	close_your_eyes
	jump
	reverse
}

const code_to_command_map = {
	0b00001: build_command_function(Command.wink)
	0b00010: build_command_function(Command.double_blink)
	0b00100: build_command_function(Command.close_your_eyes)
	0b01000: build_command_function(Command.jump)
	0b10000: build_command_function(Command.reverse)
}

fn build_command_function(command Command) fn ([]Command) []Command {
	return fn [command] (commands []Command) []Command {
		if command == .reverse {
			return commands.reverse()
		}

		mut new_commands := commands.clone()

		new_commands << command

		return new_commands
	}
}

fn commands(encoded_message int) []Command {
	mut commands := []Command{}

	for code, apply_command in code_to_command_map {
		if should_apply_command(encoded_message, code) {
			commands = apply_command(commands)
		}
	}

	return commands
}

fn should_apply_command(encoded_message int, command_code int) bool {
	return encoded_message & command_code != command_code
}
