public class SalaryCalculator {
    int BaseSalary = 1000;
    
    public double salaryMultiplier(int daysSkipped) {
        return daysSkipped < 5 ? 1.0 : 0.85;
    }

    public int bonusMultiplier(int productsSold) {
        return productsSold < 20 ? 10 : 13;
    }

    public double bonusForProductsSold(int productsSold) {
        int multiplier = bonusMultiplier(productsSold);
        return productsSold * multiplier;
    }

    public double finalSalary(int daysSkipped, int productsSold) {
        double salary = (BaseSalary * salaryMultiplier(daysSkipped)) + bonusForProductsSold(productsSold);
        return salary > 2000.00 ? 2000.00 : salary;
    } 
}
