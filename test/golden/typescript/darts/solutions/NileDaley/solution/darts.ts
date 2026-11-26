function calclulateDistance(x: number, y: number): number {
  return Math.sqrt(x**2 + y**2)
}

const points = {
  outside: 0,
  outer: 1,
  middle: 5,
  inner: 10
}

export function score(x: number, y: number): number {

  const distance = calclulateDistance(x, y)
  
  if (distance > 10) return points.outside
  if (distance > 5) return points.outer
  if (distance > 1) return points.middle
  return points.inner
  
}
