<#
.SYNOPSIS
    Given a diagram, determine which plants each child in the kindergarten class is responsible for.

.DESCRIPTION
    There are 12 children in the class:
    - Alice, Bob, Charlie, David,
    - Eve, Fred, Ginny, Harriet,
    - Ileana, Joseph, Kincaid, and Larry.
    Each child take care of 4 plants, two on each row.
    The children are being seated alphabetically from left to right.

    Note: the class constructor should accept an optional list of differnt students if provided.

.EXAMPLE
    $garden = [Garden]::new("VCCCGG`nVGCCGG")
    $garden.GetPlants("Alice")
    Return : @("Violets", "Clover", "Violets", "Grass")
#>

Class Garden {
    [string[]] $diagram;
    [string[]] $children = @(
        "Alice",
        "Bob",
        "Charlie",
        "David",
        "Eve",
        "Fred",
        "Ginny",
        "Harriet",
        "Ileana",
        "Joseph",
        "Kincaid",
        "Larry"
    )

    Garden($diagram) {
        $this.diagram = $diagram.split("`n");
        $this.children = $this.children | Sort-Object;
    }

    Garden($diagram, $children){
        $this.diagram = $diagram.split("`n");
        $this.children = $children | Sort-Object;
    }

    [string[]] GetPlants($student) {
        $student_idx = $this.children.IndexOf($student) * 2;
        return $(
            Join-String -InputObject @(
                $this.diagram[0][$student_idx..$($student_idx+1)],
                $this.diagram[1][$student_idx..$($student_idx+1)]
            ) `
            | get_plant_type
        )
    }

}

filter get_plant_type {
    foreach($plant in $_.GetEnumerator()){
        switch($plant){
            "V"{"Violets";break;}
            "R"{"Radishes";break;}
            "C"{"Clover";break;}
            "G"{"Grass";break;}
        }
    }
}