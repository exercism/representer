import ballerina/io;

type FuelEvent record {|
    int employeeId;
    int odometerReading;
    decimal gallons;
    decimal gasPrice;
|};

type EmployeeFuelRecord record {|
    int employeeId;
    int gasFillUpCount;
    decimal totalFuelCost;
    decimal totalGallons;
    int totalMilesAccrued;
|};

function readInput(string inputFilePath) returns error|FuelEvent[] {
    xmlns "http://www.so2w.org" as s;
    xml content = check io:fileReadXml(inputFilePath);
    FuelEvent[] result = [];
    foreach xml:Element x in content/**/<s:FuelEvent> {
        string employeeId = check x.employeeId;
        var odometerReading = x/<s:odometerReading>;
        var gallons = x/<s:gallons>;
        var gasPrice = x/<s:gasPrice>;
        result.push({
            employeeId: check int:fromString(employeeId),
            odometerReading: check int:fromString(odometerReading.data().trim()),
            gallons: check decimal:fromString(gallons.data().trim()),
            gasPrice: check decimal:fromString(gasPrice.data().trim())
        });
    }
    return result;
}

function computeEmployeeFuelRecord(FuelEvent[] fuelEvents) returns EmployeeFuelRecord[] {
    map<EmployeeFuelRecord> result = {};
    map<int> minimums = {};
    map<int> maximums = {};
    foreach var it in fuelEvents {
        var employeeId = it.employeeId.toString();
        EmployeeFuelRecord value;
        if result.hasKey(employeeId) {
            value = result.get(employeeId);
            if minimums.get(employeeId) > it.odometerReading {
                minimums[employeeId] = it.odometerReading;
            }
            if maximums.get(employeeId) < it.odometerReading {
                maximums[employeeId] = it.odometerReading;
            }
        } else {
            value = {
                gasFillUpCount: 0,
                totalFuelCost: 0,
                totalGallons: 0,
                totalMilesAccrued: 0,
                employeeId: it.employeeId
            };
            result[employeeId] = value;
            minimums[employeeId] = it.odometerReading;
            maximums[employeeId] = it.odometerReading;
        }
        value.gasFillUpCount += 1;
        value.totalFuelCost += it.gallons * it.gasPrice;
        value.totalGallons += it.gallons;
    }
    foreach var employeeId in result.keys() {
        EmployeeFuelRecord value = result.get(employeeId);
        value.totalMilesAccrued = maximums.get(employeeId) - minimums.get(employeeId);
    }
    return result.toArray().sort(key = isolated function(EmployeeFuelRecord r) returns int => r.employeeId);
}

function writeOutput(string outputFilePath, EmployeeFuelRecord[] result) returns error? {
    xmlns "http://www.so2w.org" as s;
    xml:Element output = xml `<s:employeeFuelRecords>${from var it in result
        select xml `<s:employeeFuelRecord employeeId="${it.employeeId}"><s:gasFillUpCount>${it.gasFillUpCount}</s:gasFillUpCount><s:totalFuelCost>${it.totalFuelCost}</s:totalFuelCost><s:totalGallons>${it.totalGallons}</s:totalGallons><s:totalMilesAccrued>${it.totalMilesAccrued}</s:totalMilesAccrued></s:employeeFuelRecord>`}</s:employeeFuelRecords>`;
    check io:fileWriteXml(outputFilePath, output);
}

function processFuelRecords(string inputFilePath, string outputFilePath) returns error? {
    var input = check readInput(inputFilePath);
    EmployeeFuelRecord[] output = computeEmployeeFuelRecord(input);
    check writeOutput(outputFilePath, output);
}
