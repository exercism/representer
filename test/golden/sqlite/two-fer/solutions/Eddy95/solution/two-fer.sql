-- Schema: CREATE TABLE "twofer" ("input" TEXT, "response" TEXT);
-- Task: update the twofer table and set the response based on the input.
insert into twofer(Input,Response)
values
    ('','One for you, one for me.'),
    ('Alice','One for Alice, one for me.'),
    ('Bob','One for Bob, one for me.'),
    ('Eddy','One for Eddy, one for me.'),
    ('','One for you, one for me.')