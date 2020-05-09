drop temporary table ordered_items;

-- Create orders and ordered items table for 2014
CREATE temporary table ordered_items
select o.order_id,
       o.created_at,
       oi.product_id,
       o.items_purchased,
       oi.is_primary_item,
       oi.order_item_id
from 
	orders o 
    JOIN
	order_items oi
    ON o.order_id = oi.order_id
where YEAR(o.created_at) >= 2014 AND YEAR(o.created_at) < 2015
;


select * from ordered_items;



-- Create orders and refund table for Tableau
select oi.created_at, 
       SUM(CASE WHEN oi.product_id=1 THEN 1 ELSE 0 end) as p1_order,
       SUM(CASE WHEN oir.order_item_id is not null AND oi.product_id=1 then 1 ELSE 0 end) as p1_order_refund,
       
       SUM(CASE WHEN oi.product_id=2 THEN 1 ELSE 0 end) as p2_order,
       SUM(CASE WHEN oir.order_item_id is not null AND oi.product_id=2 then 1 ELSE 0 end) as p2_order_refund,
       
       SUM(CASE WHEN oi.product_id=3 THEN 1 ELSE 0 end) as p3_order,
       SUM(CASE WHEN oir.order_item_id is not null AND oi.product_id=3 then 1 ELSE 0 end) as p3order_refund,
       
       SUM(CASE WHEN oi.product_id=4 THEN 1 ELSE 0 end) as p4_order,
       SUM(CASE WHEN oir.order_item_id is not null AND oi.product_id=4 then 1 ELSE 0 end) as p4_order_refund
       
from ordered_items oi
     LEFT JOIN
     order_item_refunds oir
	 ON oi.order_id = oir.order_id
where YEAR(oi.created_at) >= 2014 AND YEAR(oi.created_at) < 2015
group by YEAR(oi.created_at)
order by oi.order_id
;



