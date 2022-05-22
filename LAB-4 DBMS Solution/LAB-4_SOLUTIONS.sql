-- 1. Display the total number of customers based on gender who have placed orders of worth at least Rs.3000.
-- Ans:
SELECT cus.CUS_GENDER as Gender,COUNT(cus.CUS_ID) as COUNT 
FROM customer cus 
JOIN orders o ON cus.CUS_ID = o.CUS_ID
AND o.ORD_AMOUNT>=3000
GROUP BY (cus.CUS_GENDER) ;

-- 2. Display all the orders along with product name ordered by a customer having Customer_Id=2
-- Ans:

SELECT pro.PRO_NAME as 'Product Name',o.ORD_AMOUNT as 'Order Amount',o.ORD_DATE as 'Order Date'
FROM orders o 
JOIN Supplier_pricing sp
ON o.PRICING_ID = sp.PRICING_ID
JOIN product pro 
ON sp.PRO_ID=pro.PRO_ID
WHERE o.CUS_ID=2;

-- 3. Display the Supplier details who can supply more than one product.
-- Ans:
SELECT * from Supplier 
WHERE SUPP_ID 
IN (SELECT SUPP_ID from Supplier_pricing GROUP BY (SUPP_ID) having count(SUPP_ID)>1);


-- 4. Find the least expensive product from each category and print the table with category id, name, product name and price of the product
-- Ans:
SELECT c.cat_id ,c.CAT_NAME as 'Category Name',t2.pro_name as 'Product Name',t2.supp_price as PRICE 
from category c
inner JOIN 
(SELECT p.PRO_ID,p.pro_name,p.cat_id,min(supp_price) as supp_price FROM Supplier_pricing sp inner JOIN product p ON sp.PRO_ID=p.PRO_ID GROUP BY (p.PRO_ID) order by supp_price ) as t2
 ON c.cat_id=t2.cat_id 
 group by c.cat_id;
 
 -- 5. Display the Id and Name of the Product ordered after “2021-10-05”.
 -- Ans:
 SELECT pro.PRO_ID,pro.PRO_NAME,o.ORD_DATE
FROM orders o 
JOIN Supplier_pricing sp
ON o.PRICING_ID = sp.PRICING_ID  
JOIN product pro 
ON sp.PRO_ID=pro.PRO_ID
WHERE o.ORD_DATE>"2021-10-05" ;

-- 6. Display customer name and gender whose names start or end with character 'A'.
-- Ans:
SELECT CUS_NAME,CUS_GENDER 
FROM customer 
WHERE CUS_NAME LIKE "A%" OR CUS_NAME LIKE "%A";

-- 7. Create a stored procedure to display supplier id, name, rating and Type_of_Service. For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2 print “Average Service” else print “Poor Service”.
-- Ans:
drop procedure if exists supplier_ratings ;
DELIMITER &&  
CREATE PROCEDURE supplier_ratings ()  
BEGIN  
	
    SELECT sup.SUPP_ID as 'Supplier ID',sup.SUPP_NAME as 'Supplier Name',AVG(rate.RAT_RATSTARS) as 'Average Rating',
    CASE 
    WHEN AVG(rate.RAT_RATSTARS)=5 then "Excellent Service"
    WHEN AVG(rate.RAT_RATSTARS)>4 then "Good Service"
    WHEN AVG(rate.RAT_RATSTARS)>2 then "Average Service"
    ELSE "Poor Service"
    END as type_of_services
    FROM supplier sup 
    JOIN Supplier_pricing sp
	ON sup.SUPP_ID = sp.SUPP_ID  
    JOIN orders o
    ON sp.PRICING_ID=o.PRICING_ID
    JOIN rating rate
    ON o.ORD_ID=rate.ORD_ID GROUP BY (sup.SUPP_ID );
END &&  
DELIMITER ;  

call supplier_ratings();
  