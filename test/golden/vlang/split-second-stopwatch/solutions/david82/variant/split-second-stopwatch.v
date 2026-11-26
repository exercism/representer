module main

enum State {
	ready
	running
	stopped
}

struct Stopwatch {
mut:
	state          State
	start_time     i64
	elapsed        i64
	current_lap    i64
	previous_laps  []i64
	time_simulator TimeSimulator
}

struct TimeSimulator {
mut:
	current_time i64
}

fn (mut ts TimeSimulator) advance_time(by string) {
	// Parse time string in HH:MM:SS format and add to current time
	parts := by.split(':')
	if parts.len == 3 {
		hours := parts[0].int()
		minutes := parts[1].int()
		seconds := parts[2].int()
		ts.current_time += (hours * 3600 + minutes * 60 + seconds) * 1000
	}
}

fn (ts TimeSimulator) get_time() i64 {
	return ts.current_time
}

fn Stopwatch.new() Stopwatch {
	return Stopwatch{
		state: State.ready
		start_time: 0
		elapsed: 0
		current_lap: 0
		previous_laps: []
		time_simulator: TimeSimulator{}
	}
}

fn (stopwatch Stopwatch) state() State {
	return stopwatch.state
}

fn (stopwatch Stopwatch) current_lap() string {
	if stopwatch.state == State.running {
		current_time := stopwatch.time_simulator.get_time()
		return format_duration(stopwatch.current_lap + (current_time - stopwatch.start_time))
	}
	return format_duration(stopwatch.current_lap)
}

fn (stopwatch Stopwatch) previous_laps() []string {
	return stopwatch.previous_laps.map(format_duration)
}

fn (stopwatch Stopwatch) total() string {
	if stopwatch.state == State.running {
		current_time := stopwatch.time_simulator.get_time()
		return format_duration(stopwatch.elapsed + (current_time - stopwatch.start_time))
	}
	return format_duration(stopwatch.elapsed)
}

fn (mut stopwatch Stopwatch) start() ! {
	if stopwatch.state == State.running {
		return error('cannot start an already running stopwatch')
	}
	stopwatch.start_time = stopwatch.time_simulator.get_time()
	stopwatch.state = State.running
}

fn (mut stopwatch Stopwatch) stop() ! {
	if stopwatch.state != State.running {
		return error('cannot stop a stopwatch that is not running')
	}
	stopwatch.elapsed += stopwatch.time_simulator.get_time() - stopwatch.start_time
	stopwatch.current_lap += stopwatch.time_simulator.get_time() - stopwatch.start_time
	stopwatch.state = State.stopped
}

fn (mut stopwatch Stopwatch) reset() ! {
	if stopwatch.state != State.stopped {
		return error('cannot reset a stopwatch that is not stopped')
	}
	stopwatch.elapsed = 0
	stopwatch.current_lap = 0
	stopwatch.previous_laps = []
	stopwatch.state = State.ready
}

fn (mut stopwatch Stopwatch) advance_time(by string) {
	stopwatch.time_simulator.advance_time(by)
}

fn (mut stopwatch Stopwatch) lap() ! {
	if stopwatch.state != State.running {
		return error('cannot lap a stopwatch that is not running')
	}
	// Update current lap with elapsed time before adding to previous laps
	current_time := stopwatch.time_simulator.get_time()
	lap_time := current_time - stopwatch.start_time
	stopwatch.current_lap += lap_time
	stopwatch.elapsed += lap_time  // Add lap time to total elapsed
	stopwatch.previous_laps << stopwatch.current_lap
	stopwatch.current_lap = 0
	stopwatch.start_time = current_time
}

// Helper function to format duration in HH:MM:SS format
fn format_duration(milliseconds i64) string {
	hours := milliseconds / 3600000
	minutes := (milliseconds % 3600000) / 60000
	seconds := (milliseconds % 60000) * 1000
	return '${hours:02}:${minutes:02}:${seconds:02}'
}
   