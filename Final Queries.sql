USE surf_shop;

/* EXERCISE 1 */
/*List all the customer’s names, dates, and products or services bought by these customers in a range of two dates */

select c.name as 'Name', p.purchase_date as 'Date_of_Purchase', pr.product_name as 'Name_of_Product',
pr.product_id 
from purchase as p
	join clients as c on p.client_id= c.client_id 
    /* Joining the clients table on purchases assures that the clients selected are only the ones who actually made purchases*/
	join purchase_details as pd on p.purchase_id= pd.purchase_id
    /*Joining purchase with purchase_details is necessary to retrieve, in the following line of code, the product_ID */
    join products as pr on pd.product_id= pr.product_id
    WHERE p.purchase_date BETWEEN "2019-02-01" and "2019-12-05"; /*Only select purchases if purchase_date is between these two dates*/

/* EXERCISE 2 */
/*List the best three clients (the ones who spent the most money at our surf shop).*/ 

select  c.client_id,c.name, sum(p.purchase_value) AS Purchase_Value /*The purchase value needs to be summed because one client may have made several purchases */
from clients c
join purchase p ON c.client_id = p.client_id /*Get the clients that made purchases*/
group by client_id /*The total purchase values need to be grouped by each client's identifier */
order by Purchase_Value DESC /*The highest purchase value comes first*/
limit 3;

/* EXERCISE 3 */
/*Get the average amount of sales (in euros) by month and by year for the whole sales history.*/
select '01/2018 - 12/2020' as 'Period of Sales', /* The total time period of the store's existence */
	   sum(purchase_value) as 'Total Sales (€)', 
       sum(purchase_value)/3 as 'Yearly Average Sales (€)', /*The store existed for 3 years in operation, so it is divided by 3*/
       sum(purchase_value)/36 as 'Monthly Average Sales (€)' /*3 years implies 36 months, to get the average monthly sales value*/
 from purchase;

/* EXERCISE 4*/ 
/*Get the total sales by geographical location (city/country).*/

/* Total Sales by City*/
select ci.city_name, sum(p.purchase_value) as 'Total Purchase Value'
from (purchase p)
left join city as ci on p.city_id= ci.city_id 
/* A left join here implies that we are using all attributes from the table City, but only selecting City Name in the final output */
group by city_name; /*Grouping the total sales value by each city's name*/ 

/* Total Sales by Country*/
select co.country_name, sum(p.purchase_value) as 'Total Purchase Value'
from (purchase p)
left join city as ci on p.city_id= ci.city_id
left join country as co on ci.country_id=co.country_id
/*After selecting the city IDs where purchases occurred, we are also using all attributes from the table Country, but only selecting Country Name in the final output */
group by country_name; 

  /* EXERCISE 5*/      
/*List all the locations where products/services where sold and the product has customer’s ratings.*/

select distinct country_name, city_name
from purchase AS p, purchase_details AS pd, product_rating AS prk, city AS ci, country AS co, clients as c
where p.purchase_id = pd.purchase_id
    and prk.product_id = pd.product_id
  	and p.client_id = c.client_id
	and ci.country_id = co.country_id
	and c.city_id = ci.city_id;
/*The 'and' statements specify that we are only selecting the purchase and product ids that are present in the table Product Rating,
and all other specificities start from that ground. A product with no ratings will not be present on Product_Rating, thus not appearing in
the final output. Notice that, in the final output, Germany is not present, as products bought from Germany were not rated by any customer.*/ 
;


/* PART H  */
CREATE VIEW INVOICE_completed
	AS 
    /* Invoice Head */
   SELECT p.purchase_id AS Invoice_Id, p.purchase_date AS 'Purchase Date', 
		/* Client's Personal information */
		c.name AS 'Client Name', co.country_name AS 'Client Country',
		/* Items Bought */
        pr.product_name AS 'Product Name', pr.unit_price AS 'Unit Price', pd.quantity AS 'Quantity', pr.unit_price*pd.quantity AS 'Purchase Value',
        /* 'Please pay invoice by:' */
        p.date_max_payment AS 'Maximum Payment Date',
        /* Invoice Details */
		pd.discount AS Discount, co.tax_rate AS 'Tax Rate', (pr.unit_price*pd.quantity * co.tax_rate) AS Tax, 
        (pr.unit_price*pd.quantity - pd.discount + pr.unit_price*pd.quantity * co.tax_rate) AS 'Final Price'
        FROM purchase_details AS pd
        JOIN purchase AS p ON p.purchase_id = pd.purchase_id
		JOIN products AS pr ON pr.product_id = pd.product_id
		JOIN clients AS c ON c.client_id = p.client_id
        JOIN city AS ci ON ci.city_id = c.city_id
        JOIN country AS co ON ci.country_id = co.country_id
        JOIN (SELECT pd.purchase_id, SUM(pr.unit_price * pd.quantity) AS order_subtotal
			FROM purchase_details AS pd, products AS pr
			WHERE pd.product_id = pr.product_id
			GROUP BY pd.purchase_id) AS subtotal_table ON subtotal_table.purchase_id = p.purchase_id
	ORDER BY p.purchase_id;
    
    /* Example of an order invoice */
SELECT * FROM invoice_completed;

CREATE VIEW INVOICE_simplified
	AS 
    /* Invoice Head */
   SELECT p.purchase_id AS Invoice_Id, p.purchase_date AS 'Purchase Date', 
		/* Client's Personal information */
		c.name AS 'Client Name', co.country_name AS 'Client Country',   
        /* Invoice Details */
        (pr.unit_price*pd.quantity - pd.discount + pr.unit_price*pd.quantity * co.tax_rate) AS 'Final Price'
        FROM purchase_details AS pd
        JOIN purchase AS p ON p.purchase_id = pd.purchase_id
		JOIN products AS pr ON pr.product_id = pd.product_id
		JOIN clients AS c ON c.client_id = p.client_id
        JOIN city AS ci ON ci.city_id = c.city_id
        JOIN country AS co ON ci.country_id = co.country_id
        JOIN (SELECT pd.purchase_id, SUM(pr.unit_price*pd.quantity) AS order_subtotal
			FROM purchase_details AS pd, products AS pr
			WHERE pd.product_id = pr.product_id
			GROUP BY pd.purchase_id) AS subtotal_table ON subtotal_table.purchase_id = p.purchase_id
	ORDER BY p.purchase_id;
    
    /* Simplified invoice*/
SELECT * FROM invoice_simplified;