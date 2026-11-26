-- Schema: CREATE TABLE "raindrops" ("number" INT, "sound" TEXT);
-- Task: update the raindrops table and set the sound based on the number.
update raindrops set sound = case
when number % 105 = 0 then 'PlingPlangPlong' 
when number % 35 = 0 then 'PlangPlong'
when number % 15 = 0 then 'PlingPlang'
when number % 21 = 0 then 'PlingPlong'
when number % 7 = 0 then 'Plong'
when number % 5 = 0 then 'Plang'
when number % 3 = 0 then 'Pling'
else number
end;
