th og_set as (
  select orders.orderid as orderid, orders.customerid as customer, productid from orders
  join order_details on order_details.orderid = orders.orderid
),
grouped_set as (
  select orderid, customer, array_agg(productid) as products
  from og_set
  group by orderid, customer
  order by orderid asc
),
ranked_set as (
  select orderid, customer, products, dense_rank() over (order by array_length(products, 1) asc) as rank
  from grouped_set order by rank asc
),
first_in_first as (
  select * from ranked_set where rank = 1 limit 1
),
first_in_second as (
  select * from ranked_set where rank = 2 limit 1
),
first_in_third as (
  select * from ranked_set where rank = 3 limit 1
),
first_in_fourth as (
  select * from ranked_set where rank = 4 limit 1
),
first_in_fifth as (
  select * from ranked_set where rank = 5 limit 1
),
first_in_sixth as (
  select * from ranked_set where rank = 6 limit 1
),
first_in_seventh as (
  select * from ranked_set where rank = 7 limit 1
),
first_of_all_ranks as (
  select * from first_in_first
  union
  select * from first_in_second
  union
  select * from first_in_third
  union
  select * from first_in_fourth
  union
  select * from first_in_fifth
  union
  select * from first_in_sixth
  union
  select * from first_in_seventh
  order by rank asc
)
select * from first_of_all_ranks;

