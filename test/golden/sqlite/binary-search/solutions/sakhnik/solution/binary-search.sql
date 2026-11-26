update "binary-search"
set (result, error) = (
  with recursive search(i, l, m, r) as (
    values (0, 0, json_array_length(array) / 2, json_array_length(array))
    union all
    select i+1, m+1, (m+r+1)/2, r
      from search
     where l < r and array ->> m < value
    union all
    select i+1, l, (l+m)/2, m
      from search
     where l < r and array ->> m > value
  )
  select iif(array ->> m = value, m, null),
         iif(array ->> m = value, null, 'value not in array')
  from search
  order by i desc
  limit 1
);
