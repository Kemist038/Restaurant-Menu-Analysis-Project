
USE Restaurant_db;

SELECT * FROM Menu_Items;
SELECT * FROM order_details;

DESCRIBE menu_items;
DESCRIBE order_details;


# To Get distinct Items from the menu

SELECT 
	COUNT(DISTINCT(Menu_Item_id)) AS Total_Items_in_Menu 
FROM 
	menu_items;

# No of menu items as per Category and its Average, Max , and Min Prices

SELECT 
	Category,
    COUNT(menu_item_id) AS No_of_Items,
    MIN(price) AS Min_Price,
    ROUND(AVG(price),2) AS Average_Price,
    MAX(Price) AS Max_Price
FROM 
	menu_items
GROUP BY category;

SELECT * FROM order_details;


# Find Date Interval
SELECT MAX(Order_Date) AS First_Date , MIN(Order_Date) AS Last_Date
FROM order_details;

# Find Each Month Total Orders
SELECT 
	(CASE 
		WHEN ORDER_Date BETWEEN "2023-01-01" AND "2023-01-31" THEN "Januray_23"
        WHEN ORDER_Date BETWEEN "2023-02-01" AND "2023-02-28" THEN "February_23"
        WHEN ORDER_Date BETWEEN "2023-03-01" AND "2023-03-31" THEN "March_23"
        ELSE "Not_Written"
        END) AS Month_and_Year,
	COUNT(DISTINCT(order_Id)) AS Total_Orders,
	COUNT(order_details_Id) AS Total_Items
FROM 
	order_details
GROUP BY Month_and_Year;



# Total_order and Items with Time Interval

SELECT MAX(Order_Time), Min(Order_Time) FROM order_details;

SELECT
	(CASE 
    WHEN Order_Time BETWEEN "10:00:00" AND "14:00:00" THEN "10_to_14"
    WHEN Order_Time BETWEEN "14:00:01" AND "17:00:00" THEN "14_to_17"
    WHEN Order_Time BETWEEN "17:00:01" AND "20:00:00" THEN "17_to_20"
    WHEN Order_Time BETWEEN "20:00:01" AND "24:00:00" THEN "20_to_24"
    ELSE "Not Written"
    END) AS Time_Interval,
    COUNT(DISTINCT(Order_Id)) AS Total_Order,
    COUNT(order_details_Id) AS Total_Items
FROM order_details
GROUP BY Time_Interval;

# Order with How many Items.
SELECT 
	Order_Id, 
    COUNT(order_details_Id) AS Total_Items 
FROM 
	order_details
GROUP BY Order_Id
ORDER BY Total_Items DESC;

# Orders greater then 12 items orderd
SELECT Order_Id, COUNT(order_details_Id) AS Total_Items 
FROM order_details
GROUP BY Order_Id
HAVING Total_items > 12
ORDER BY 2 DESC;


SELECT * FROM Menu_items;
SELECT * FROM order_details;

# Joining menu and order table
SELECT *
FROM
	Menu_Items AS Mi
    LEFT JOIN
    Order_Details AS Od ON mi.Menu_Item_Id = od.Item_id;

# Items Ordered AS per Category of food
SELECT mi.Category, COUNT(od.Item_Id) AS Total_Items_Ordered
FROM
	Menu_Items AS Mi
    INNER JOIN
    Order_Details AS Od ON mi.Menu_Item_Id = od.Item_Id
GROUP BY 1;


# What are the most and least ordered items?
SELECT od.Item_id, mi.item_name, COUNT(od.order_details_id) AS total_times_Ordered 
FROM order_details AS od
	INNER JOIN
    menu_items AS mi ON od.item_id = mi.menu_Item_id
GROUP BY 1,2
ORDER BY 3 DESC;


# Top 5 order that spent most amount
SELECT om.Order_Id, Sum(om.Total_Price) AS Total_Spend
FROM (SELECT od.Order_Id, mi.menu_item_Id, SUM(mi.Price) AS Total_Price
FROM 
	Order_Details AS od
    INNER JOIN
    Menu_Items AS mi ON od.Item_Id = mi.Menu_Item_id
GROUP BY od.Order_Id, mi.menu_item_Id) AS om
GROUP BY om.Order_Id
ORDER BY Total_Spend DESC;

# OR 

SELECT od.Order_Id, SUM(mi.Price) AS Total_Spend
FROM 
	Order_Details AS od
    INNER JOIN
    Menu_Items AS mi ON od.Item_Id = mi.Menu_Item_id
GROUP BY od.Order_Id
ORDER BY Total_Spend DESC;



# Highest Order what was it purchased
SELECT mi.Category,SUM(mi.Price) as Spend
FROM 
	Order_Details AS od
    LEFT JOIN
    Menu_Items AS mi ON od.Item_Id = mi.Menu_Item_id
WHERE od.Order_id IN(440,2075,1957,330,2675) AND od.item_id IS NULL	
GROUP BY mi.Category;



# Find Each Month Total Orders
SELECT * FROM menu_items;
SELECT * FROM order_details;
SELECT 
	MAX(order_date),
    MIN(order_date) 
FROM 
	order_details;

SELECT
	CASE
		WHEN order_date BETWEEN "2023-01-01" AND "2023-01-31" THEN "January 2023"
        WHEN order_date BETWEEN "2023-02-01" AND "2023-02-28" THEN "February 2023"
        WHEN order_date BETWEEN "2023-03-01" AND "2023-03-31" THEN "March 2023"
	END AS Month_Name,
    COUNT(DISTINCT(order_id)) AS Total_orders,
    COUNT(order_details_id) AS Total_Items
FROM
	order_details
GROUP BY Month_Name;

# Gross Income made by Restaurent
SELECT 
	(CASE 
		WHEN odetail.ORDER_Date BETWEEN "2023-01-01" AND "2023-01-31" THEN "Januray_23"
        WHEN odetail.ORDER_Date BETWEEN "2023-02-01" AND "2023-02-28" THEN "February_23"
        WHEN odetail.ORDER_Date BETWEEN "2023-03-01" AND "2023-03-31" THEN "March_23"
        ELSE "Not_Written"
        END) AS Month_and_Year,
        SUM(mitems.price) AS Gross_income
FROM 
	Order_details AS odetail
INNER JOIN
	menu_items AS mitems ON mitems.menu_item_id = odetail.item_id
GROUP BY Month_and_Year;

# Total Income shown by items.
SELECT 
	odetail.Item_id, mitems.Item_Name, SUM(mitems.Price) AS Income_Through_Item
FROM 
	Order_details AS odetail
INNER JOIN
	menu_items AS mitems ON mitems.menu_item_id = odetail.item_id
GROUP BY odetail.Item_id
ORDER BY Income_Through_Item DESC;
