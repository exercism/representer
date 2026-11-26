const std = @import("std");
const mem = std.mem;

pub const StopwatchError = error{
    AlreadyRunning,
    NotRunning,
    NotStopped,
};

pub const StopwatchState = enum {
    ready,
    running,
    stopped,
};

pub const Stopwatch = struct {
    prev_laps: std.array_list.Managed(Time),
    curr_lap: Time,
    state: StopwatchState,

    const Time = struct {
        hours: u8,
        mins: u8,
        secs: u8,

        const Self = @This();

        pub fn init(hours: u8, mins: u8, secs: u8) Self {
            return .{ .hours = hours, .mins = mins, .secs = secs };
        }

        pub fn into(self: Self) ![8]u8 {
            var buf: [8]u8 = undefined;
            _ = try std.fmt.bufPrint(&buf, "{d:02}:{d:02}:{d:02}", .{ self.hours, self.mins, self.secs });
            return buf;
        }

        pub fn add(self: *Self, other: Self) void {
            const minsInHour = 60;
            const hoursInDay = 24;
            const totalSecs = self.secs + other.secs;
            const totalMins = self.mins + other.mins;
            const secs = @mod(totalSecs, minsInHour);
            const mins = @mod(totalMins + (@divFloor(totalSecs, minsInHour)), minsInHour);
            const hours = @mod(self.hours + other.hours + (@divFloor(totalMins, minsInHour)), hoursInDay);
            self.hours = hours;
            self.mins = mins;
            self.secs = secs;
        }

        pub fn reset(self: *Self) void {
            self.hours = 0;
            self.mins = 0;
            self.secs = 0;
        }
    };

    pub fn init(allocator: mem.Allocator) Stopwatch {
        return .{
            .prev_laps = std.array_list.Managed(Time).init(allocator),
            .curr_lap = Time.init(0, 0, 0),
            .state = StopwatchState.ready,
        };
    }

    pub fn deinit(self: *Stopwatch) void {
        return self.prev_laps.deinit();
    }

    pub fn currentLap(self: *Stopwatch) [8]u8 {
        return self.curr_lap.into() catch unreachable;
    }

    pub fn previousLaps(self: *Stopwatch) mem.Allocator.Error![][8]u8 {
        var laps = try std.array_list.Managed([8]u8).initCapacity(
            self.prev_laps.allocator,
            self.prev_laps.items.len,
        );
        for (self.prev_laps.items) |time| {
            try laps.append(time.into() catch unreachable);
        }
        return laps.toOwnedSlice();
    }

    pub fn total(self: *Stopwatch) [8]u8 {
        var time: Time = self.curr_lap;
        for (self.prev_laps.items) |item| {
            time.add(item);
        }
        return time.into() catch unreachable;
    }

    pub fn start(self: *Stopwatch) StopwatchError!void {
        if (self.state == StopwatchState.running) return StopwatchError.AlreadyRunning;
        self.state = StopwatchState.running;
    }

    pub fn stop(self: *Stopwatch) StopwatchError!void {
        if (self.state == StopwatchState.ready and self.state == StopwatchState.stopped) return StopwatchError.NotRunning;
        self.state = StopwatchState.stopped;
    }

    pub fn reset(self: *Stopwatch) StopwatchError!void {
        if (self.state == StopwatchState.ready or self.state == StopwatchState.running) return StopwatchError.NotStopped;
        self.state = StopwatchState.ready;
        self.prev_laps.clearAndFree();
        self.curr_lap.reset();
    }

    pub fn advanceTime(self: *Stopwatch, by: []const u8) !void {
        var buf: [3]u8 = undefined;
        var it = std.mem.tokenizeScalar(u8, by, ':');
        var i: usize = 0;
        while (it.next()) |data| : (i += 1) {
            buf[i] = try std.fmt.parseInt(u8, data, 10);
        }
        if (self.state != StopwatchState.stopped) {
            self.curr_lap.add(Time.init(buf[0], buf[1], buf[2]));
        }
    }

    pub fn lap(self: *Stopwatch) (mem.Allocator.Error || StopwatchError)!void {
        if (self.state == StopwatchState.ready or self.state == StopwatchState.stopped) return StopwatchError.NotRunning;
        try self.prev_laps.append(self.curr_lap);
        self.curr_lap.reset();
    }
};
