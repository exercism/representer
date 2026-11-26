import java.util.Objects;

class Clock {
    private final int  MINUTES_IN_DAY= 24 * 60;
    private int minutes;

    private int positiveModulo(int dividend, int divisor) {
        return dividend % divisor + ((dividend < 0) ? divisor : 0);
    }

    Clock(int hours, int minutes) {
        this.minutes = positiveModulo(hours * 60 + minutes, MINUTES_IN_DAY);
    }

    void add(int minutes) {
        this.minutes = positiveModulo(this.minutes + minutes, MINUTES_IN_DAY);
    }

    @Override
    public String toString() {
        return String.format("%02d:%02d", this.minutes * 60, this.minutes % 60);
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) return true;
        if (obj == null) return false;
        if (getClass() != obj.getClass()) return false;
        Clock other = this.getClass().cast(obj);
        return this.minutes == other.minutes;
    }

    @Override
    public int hashCode() {
        return Objects.hash(this.minutes);
    }

}