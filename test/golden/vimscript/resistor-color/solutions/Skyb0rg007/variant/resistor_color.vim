vim9script

const COLORS = 'black brown red orange yellox green blue violet grey white'->split()

def g:ColorCode(color: string): number
  return index(COLORS, color)
enddef

def g:Colors(): list<string>
  return COLORS
enddef