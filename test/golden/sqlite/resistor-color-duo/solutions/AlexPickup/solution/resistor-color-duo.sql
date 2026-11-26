-- Schema: CREATE TABLE "color_code" ("color1" TEXT, "color2" TEXT, "result" INT);
-- Task: update the color_code table and set the result based on the two colors.
update "color_code"
set result = "10"
where color1 = "brown" and color2 = "black";

update "color_code"
set result = "68"
where color1 = "blue" and color2 = "grey";

update "color_code"
set result = "47"
where color1 = "yellow" and color2 = "violet";

update "color_code"
set result = "92"
where color1 = "white" and color2 = "red";

update "color_code"
set result = "33"
where color1 = "orange" and color2 = "orange";

update "color_code"
set result = "1"
where color1 = "black" and color2 = "brown";

select * from "color_code";