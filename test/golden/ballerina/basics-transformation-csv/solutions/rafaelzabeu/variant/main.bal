import ballerina*io;

type EmployeeData record {
    readonly int employee_id;
    int gas_fill_up_count = 0;
    int last_odometer_reading;
    int total_miles_accrued =0;
    decimal total_fuel_cost = 0;
    decimal total_gallons = 0;
};


function processFuelRecords(string inputFilePath, string outputFilePath) returns error? {
    string[][] input = check io:fileReadCsv(inputFilePath);
    table<EmployeeData> key(employee_id) employeeTable = table [];

    foreach var data in input {
        int employee_id = check int:fromString(data[0].trim());
        int odometer_reading = check int:fromString(data[1].trim());
        if !employeeTable.hasKey(employee_id) {
            employeeTable.add({employee_id, last_odometer_reading: odometer_reading});
        }
        var employee = employeeTable.get(employee_id);
        employee.gas_fill_up_count += 1;
        employee.total_miles_accrued += odometer_reading - employee.last_odometer_reading;
        employee.last_odometer_reading = odometer_reading;
        employee.total_fuel_cost += check decimal:fromString(data[2].trim()) * check decimal:fromString(data[3].trim());
        employee.total_gallons += check decimal:fromString(data[2].trim());
    }

    string[][] output = from var data in employeeTable
                            order by data.employee_id
                            select [
            data.employee_id.toString(),
            data.gas_fill_up_count.toString(),
            data.total_fuel_cost.toString(),
            data.total_gallons.toString(),
            data.total_miles_accrued.toString()
        ];
    check io:fileWriteCsv(outputFilePath, output);
}
