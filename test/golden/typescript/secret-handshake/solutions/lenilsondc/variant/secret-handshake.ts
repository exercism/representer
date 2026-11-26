type Action = 'wink' | 'double blink' | 'close your eyes' | 'jump'

type Op = 0b00001 | 0b00010 | 0b00100 | 0b01000 | 0b10000

const ops: Array<[op: Op, apply: (l: Action[]) => Action[]]> = [
  [0b00001, l => l.concat('wink')],
  [0b00010, l => l.concat('double blink')],
  [0b00100, l => l.concat('close your eyes')],
  [0b01000, l => l.concat('jump')],
  [0b10000, l => l.reverse()],
]

export function commands(n: number): Action[] {
  const initialCmds: Action[] = []

  return ops.reduce((cmds, [op, apply]) => {
    return (n & op) !== op ? apply(cmds) : cmds
  }, initialCmds);
}