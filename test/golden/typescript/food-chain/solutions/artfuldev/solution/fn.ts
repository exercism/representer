export const flow = <A extends any[], B, C>(
  ab: (...a: A) => B,
  bc: (b: B) => C
): (...a: A) => C  =>
  (...a: A) =>
    bc(ab(...a));

export const flip = <A, B, C>(
  f: (a: A) => (b: B) => C
) =>
  (b: B) =>
    (a: A) =>
      f(a)(b);