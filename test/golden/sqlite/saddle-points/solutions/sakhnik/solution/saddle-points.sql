update "saddle-points"
set result = (
  with
    dims(width, height) as (
      select json_array_length(matrix->>0), json_array_length(matrix)
    ),
    maximums(row, max_height) as (
      select s1.value, (select max(value) from json_each(matrix->>s1.value))
      from dims
      join generate_series(0, height-1) as s1
    ),
    minimums(col, min_height) as (
      select s1.value, (select min(matrix->>s2.value->>s1.value) from dims join generate_series(0, height-1) as s2)
      from dims
      join generate_series(0, width-1) as s1
    )
  select json_group_array(json_object('row', row+1, 'column', col+1))
  from minimums
  join maximums on min_height = max_height
);
