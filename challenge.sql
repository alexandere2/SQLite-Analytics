-- Tool & Validation Description:
-- Used SQLite 
-- Created small sample rows for each table, ran each query to confirm it returns expected aggregates, checked that line totals = quantity * unit_price and that Delivered-filtered variants reduce totals where appropriate


-- Task 1: Top 5 Customers by Total Spend  -- 
SELECT c.first_name || ' ' || c.last_name AS Customers,
ROUND(SUM(oi.quantity * oi.unit_price), 2) AS Total_Spend
FROM customers c
JOIN orders o ON o.customer_id = c.id
JOIN order_items oi ON oi.order_id = o.id
GROUP BY c.id
ORDER BY Total_Spend DESC
LIMIT 5;

-- Task 2: Total Revenue by Product Category --
SELECT p.category AS Category,
ROUND(SUM(oi.quantity * oi.unit_price), 2) AS Revenue
FROM products p
JOIN order_items oi ON oi.product_id = p.id
JOIN orders o ON o.id = oi.order_id
GROUP BY p.category 
ORDER BY Revenue DESC;

-- Task 2 Variant(Optional) --
SELECT p.category AS Category,
ROUND(SUM(oi.quantity * oi.unit_price), 2) AS Revenue_Delivered_Orders
FROM products p 
JOIN order_items oi ON oi.product_id = p.id
JOIN orders o ON o.id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY p.category
ORDER BY Revenue_Delivered_Orders DESC;

-- Task 3: Employees Earning Above Their Department Average -- 
WITH dept_avg AS (
SELECT
department_id,
AVG(salary) AS dept_avg
FROM employees
GROUP BY department_id
)
SELECT
e.first_name AS Employee_First_Name,
e.last_name AS Employee_Last_Name,
d.name AS Department_Name,
e.salary AS Employee_Salary,
ROUND(da.dept_avg, 2) AS Department_Average
FROM employees e
JOIN dept_avg da ON e.department_id = da.department_id
LEFT JOIN departments d ON d.id = e.department_id
WHERE e.salary > da.dept_avg
ORDER BY Department_Name, Employee_Salary DESC;

-- Task 4: Cities with the Most Loyal Customers -- 
SELECT city AS City,
SUM(CASE WHEN loyalty_level = 'Gold' THEN 1 ELSE 0 END) AS Gold_Count,
SUM(CASE WHEN loyalty_level = 'Silver' THEN 1 ELSE 0 END) AS Silver_Count,
SUM(CASE WHEN loyalty_level = 'Bronze' THEN 1 ELSE 0 END) AS Bronze_Count,
COUNT(*) AS Total_Customers FROM customers
GROUP BY city 
ORDER BY Gold_Count DESC, city ASC;







