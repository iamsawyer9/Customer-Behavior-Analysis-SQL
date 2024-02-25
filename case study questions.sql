#-What is the total amount each customer spent at the restaurant?#
SELECT s.customer_id, SUM(m.price) AS total_spent
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY total_spent desc;

#How many days has each customer visited the restaurant?#
select customer_id,count(distinct order_date)as days_visited
from sales
group by customer_id
order by customer_id;

#What was the first item from the menu purchased by each customer?#
SELECT 
    s.customer_id, 
    s.order_date AS first_purchase_date, 
    m.product_name
FROM 
    sales s
JOIN 
    menu m ON s.product_id = m.product_id
INNER JOIN 
    (SELECT customer_id, MIN(order_date) AS first_order_date
     FROM sales
     GROUP BY customer_id) AS first_purchase ON s.customer_id = first_purchase.customer_id 
                                             AND s.order_date = first_purchase.first_order_date;


#What is the most purchased item on the menu and how many times was it purchased by all customers?#
SELECT 
    m.product_name, 
    COUNT(s.product_id) AS total_purchases
FROM 
    sales s 
JOIN 
    menu m ON s.product_id = m.product_id -- Correctly alias the menu table here
GROUP BY 
    m.product_name
ORDER BY 
    total_purchases DESC
LIMIT 1;

#Which item was purchased first by the customer after they became a member?#
SELECT 
    first_purchase.customer_id, 
    first_purchase.first_purchase_after_joining, 
    m.product_name
FROM 
    (SELECT 
         s.customer_id, 
         MIN(s.order_date) AS first_purchase_after_joining
     FROM 
         sales s
     JOIN 
         members mem ON s.customer_id = mem.customer_id
     WHERE 
         s.order_date > mem.join_date
     GROUP BY 
         s.customer_id) AS first_purchase
JOIN 
    sales s ON first_purchase.customer_id = s.customer_id AND first_purchase.first_purchase_after_joining = s.order_date
JOIN 
    menu m ON s.product_id = m.product_id;


#What is the total items and amount spent for each member before they became a member?#
SELECT 
    s.customer_id, 
    COUNT(s.product_id) AS total_items_purchased,
    SUM(m.price) AS total_amount_spent
FROM 
    sales s
JOIN 
    menu m ON s.product_id = m.product_id
JOIN 
    members mem ON s.customer_id = mem.customer_id
WHERE 
    s.order_date < mem.join_date
GROUP BY 
    s.customer_id;
    
#If each $1 spent equates to 10 points and sushi has a 2x points multiplier how many points would each customer have?#    
SELECT 
    s.customer_id, 
    SUM(
        CASE 
            WHEN m.product_name = 'sushi' THEN m.price * 20 -- Applying 2x multiplier for sushi
            ELSE m.price * 10
        END
    ) AS total_points
FROM 
    sales s
JOIN 
    menu m ON s.product_id = m.product_id
GROUP BY 
    s.customer_id;

