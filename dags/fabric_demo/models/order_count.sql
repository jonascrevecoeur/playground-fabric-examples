select customer.first_name, customer.last_name, count(*) as num_orders from {{ref('customers')}} customer
left join {{ref('orders')}} orders
on customer.id = orders.user_id
group by customer.first_name, customer.last_name
