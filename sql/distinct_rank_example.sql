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

distinct_groups as (
  select distinct on (rank) orderid, customer, products, rank
  from ranked_set
)
select products, products[1] as first_element, products[(array_length(products, 1))] as last_element 
from distinct_groups

