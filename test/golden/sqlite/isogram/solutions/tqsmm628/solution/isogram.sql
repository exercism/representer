-- Schema: CREATE TABLE "isogram" ("phrase" TEXT, "is_isogram" INT);
-- Task: Given a phrase, determine if it is an isogram.

update isogram
set is_isogram = (with splits(c, i) as (
                      select substr(phrase, 1, 1), 1
                      union all
                      select substr(phrase, i + 1, 1), i + 1
                      from splits
                      where i < length(phrase)
                  )
                  select not exists(
                      select count(1) > 1
                      from splits
                      where c glob '[a-zA-Z]'
                      group by lower(c)
                      having count(1) > 1
                  ));
