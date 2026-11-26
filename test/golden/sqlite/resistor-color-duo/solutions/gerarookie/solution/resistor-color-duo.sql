-- Schema: CREATE TABLE "color_code" ("color1" TEXT, "color2" TEXT, "result" INT);
-- Task: update the color_code table and set the result based on the two colors.
CREATE TABLE color_map(color TEXT,number INT);
INSERT INTO color_map(color,number) VALUES ("black",0),
    ("brown",1),
    ("red",2),
    ("orange",3),
    ("yellow",4),
    ("green",5),
    ("blue",6),
    ("violet",7),
    ("grey",8),
    ("white",9);
    
update color_code set result = color_map.number*10 FROM color_map WHERE color_map.color = color_code.color1;
update color_code set result = result + color_map.number FROM color_map WHERE color_map.color = color_code.color2;