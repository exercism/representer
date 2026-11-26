public class SalaryCalculator {
    public double salaryMultiplier(int daysSkipped) {
        return daysSkipped >= 5 ? 0.85D : 1D;
    }

    public int bonusMultiplier(int productsSold) {
        return productsSold > 20 ? 13 : 10;
    }

    public double bonusForProductsSold(int productsSold) {
        return productsSold * bonusMultiplier(productsSold);
    }

    public double finalSalary(int daysSkipped, int productsSold) {
        double result = 1000 * salaryMultiplier(daysSkipped) + bonusForProductsSold(productsSold);
        return Math.min(2000.00, result);
    } 
}
