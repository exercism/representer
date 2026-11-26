class Darts {
    int score(double xOfDart, double yOfDart) {
        xOfDart=Math.abs(xOfDart);
        yOfDart=Math.abs(yOfDart);
        double c2=Math.pow(xOfDart,2.0)+Math.pow(yOfDart,2.0);
        double raggio=Math.sqrt(c2);
            if (raggio>10.0) return 0;
            if (raggio >5.0) return 1;
            if (raggio >1.0) return 5;
        
        return 10;
    }
}
