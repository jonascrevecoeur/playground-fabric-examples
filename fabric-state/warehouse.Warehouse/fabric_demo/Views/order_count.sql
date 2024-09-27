create view "fabric_demo"."order_count" as select customer.first_name, customer.last_name, count(*) as num_orders from "warehouse"."fabric_demo_raw"."customers" customer
left join "warehouse"."fabric_demo_raw"."orders" orders
on customer.id = orders.user_id
group by customer.first_name, customer.last_name;