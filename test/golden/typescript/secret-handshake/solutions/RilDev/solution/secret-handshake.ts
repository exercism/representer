export function commands(value: number) {
  return [
    value & 1 && "wink",
    value & 2 && "double blink",
    value & 4 && "close your eyes",
    value & 8 && "jump"
  ].filter(Boolean)[value & 16 ? "reverse" : "slice"]();
}
