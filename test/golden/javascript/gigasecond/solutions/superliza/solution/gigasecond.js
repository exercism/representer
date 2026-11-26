const GIGASECONDS_IN_MILLISECONDS = 1e12;

export const gigasecond = (dateMilliseconds) => {
  return new Date(dateMilliseconds.getTime() + GIGASECONDS_IN_MILLISECONDS);
}