USE [WideWorldImporters]
GO

/*Q1*/
SELECT FullName , PhoneNumber, FaxNumber FROM WideWorldImporters.Application.People;

SELECT * FROM WideWorldImporters.Application.People;


/*Q2*/
SELECT WideWorldImporters.Sales.Customers.PrimaryContactPersonID , WideWorldImporters.Application.People.PersonID, 

SELECT * FROM WideWorldImporters.Sales.Customers WHERE 

SELECT PrimaryContactPersonID FROM WideWorldImporters.Sales.Customers
INNER JOIN WideWorldImporters.Application.People 
ON WideWorldImporters.Sales.Customers.PhoneNumber = WideWorldImporters.Application.People;

SELECT * FROM WideWorldImporters.Application.People WHERE 
(SELECT PrimaryContactPersonID FROM WideWorldImporters.Sales.Customers);

/*Q3*/
SELECT C.*, O.OrderDate, O.CustomerID 
FROM  WideWorldImporters.Sales.Customers C, WideWorldImporters.Sales.Orders O
WHERE C.CustomerID =  O.CustomerID 
AND (O.OrderDate < '2016-01-01');

/*Q4*/
SELECT * FROM WideWorldImporters.Sales.Invoices;
SELECT *FROM WideWorldImporters.Sales.InvoiceLines;
SELECT * FROM WideWorldImporters.Sales.Orders WHERE OrderDate like '2013%';

SELECT A.StockItemID, A.Description, A.Quantity, C.OrderDate FROM WideWorldImporters.Sales.InvoiceLines A
INNER JOIN WideWorldImporters.Sales.Invoices B ON B.InvoiceID = A.InvoiceID
INNER JOIN WideWorldImporters.Sales.Orders C ON C.OrderID = B.OrderID AND  C.OrderDate like '2013%';

/*Q5*/
SELECT * FROM WideWorldImporters.Sales.InvoiceLines A WHERE LEN(A.Description) > 9;

/*Q6*/
 
SELECT * FROM WideWorldImporters.Warehouse.StockItems 
WHERE StockItemID IN ( 
	SELECT DISTINCT StockItemID FROM WideWorldImporters.Sales.OrderLines 
	WHERE OrderID IN ( SELECT OrderID FROM WideWorldImporters.Sales.Orders
		WHERE OrderDate like '2014%' AND CustomerID NOT IN ( 
			SELECT CustomerID FROM WideWorldImporters.Sales.Customers 
			WHERE PostalCityID IN (	
				SELECT CityID FROM WideWorldImporters.Application.Cities
				WHERE StateProvinceID IN (1,11) )
		)
	)
);

/* Q7 */

SELECT sp.StateProvinceName,
AVG(datediff(day,o.OrderDate,i.ConfirmedDeliveryTime)) as AVGDeliveryTime
FROM WideWorldImporters.Sales.Orders o
INNER Join WideWorldImporters.Sales.Invoices i
ON o.OrderID = i.OrderID
INNER join WideWorldImporters.Sales.Customers cs
ON o.CustomerID = cs.CustomerID
INNER join WideWorldImporters.Application.Cities ct
ON cs.PostalCityID = ct.CityID
INNER join WideWorldImporters.Application.StateProvinces sp
ON ct.StateProvinceID = sp.StateProvinceID
GROUP BY sp.StateProvinceName
Order by sp.StateProvinceName;

/*Q8*/
/*------------------*/
/* Q9 */

SELECT * FROM WideWorldImporters.Warehouse.StockItems 
WHERE StockItemID IN (
SELECT pol.StockItemID
FROM WideWorldImporters.Purchasing.PurchaseOrderLines pol
INNER JOIN WideWorldImporters.Purchasing.PurchaseOrders po
ON po.PurchaseOrderID = pol.PurchaseOrderID
INNER JOIN WideWorldImporters.Sales.OrderLines ol
ON pol.StockItemID = ol.StockItemID
INNER JOIN WideWorldImporters.Sales.Orders o
ON ol.OrderID = o.OrderID
WHERE po.OrderDate like '2015%' AND o.OrderDate like '2015%'
GROUP BY pol.StockItemID
HAVING sum(pol.ReceivedOuters) > sum(ol.Quantity)
) ORDER BY StockItemID;

SELECT pol.StockItemID,
sum(pol.ReceivedOuters) AS sumBuy, sum(ol.Quantity) AS sumSold
FROM WideWorldImporters.Purchasing.PurchaseOrderLines pol
INNER JOIN WideWorldImporters.Purchasing.PurchaseOrders po
ON po.PurchaseOrderID = pol.PurchaseOrderID
INNER JOIN WideWorldImporters.Sales.OrderLines ol
ON pol.StockItemID = ol.StockItemID
INNER JOIN WideWorldImporters.Sales.Orders o
ON ol.OrderID = o.OrderID
WHERE po.OrderDate like '2015%' AND o.OrderDate like '2015%'
GROUP BY pol.StockItemID
HAVING sum(pol.ReceivedOuters) > sum(ol.Quantity);

/* Q10 */

SELECT * FROM WideWorldImporters.Sales.OrderLines ol
INNER JOIN WideWorldImporters.Sales.Orders o
ON ol.OrderID = o.OrderID
WHERE ol.Description like '%mug%';

/* Q11 */Not Completed

SELECT * FROM WideWorldImporters.Application.Cities;

/* Q12 */

SELECT s.StockItemName, 
c.DeliveryAddressLine2 , c.DeliveryAddressLine1, c.DeliveryPostalCode,
ct.CityName,sp.StateProvinceName, c.CustomerName, p.FullName,
c.PhoneNumber, ol.Quantity
FROM WideWorldImporters.Sales.Orders o
INNER Join WideWorldImporters.Sales.OrderLines  ol
ON o.OrderID = ol.OrderID
INNER join WideWorldImporters.Warehouse.StockItems s
ON ol.StockItemID = s.StockItemID
INNER join WideWorldImporters.Sales.Customers c
ON o.CustomerID = c.CustomerID
INNER join WideWorldImporters.Application.People p
ON c.PrimaryContactPersonID = p.PersonID
INNER join WideWorldImporters.Application.Cities ct
ON c.DeliveryCityID = ct.CityID
INNER join WideWorldImporters.Application.StateProvinces sp
on ct.StateProvinceID = sp.StateProvinceID
WHERE o.OrderDate = '2014-07-01';

/* Q13 */

SELECT sg.StockGroupID,sg.StockGroupName, 
sum(ol.Quantity) AS TotalQuantitySold,
sum(CAST(pol.ReceivedOuters AS BIGINT)) AS TotalQuantityPurchased,
(sum(CAST(pol.ReceivedOuters AS BIGINT)) - sum(ol.Quantity)) AS RemainingStock
FROM WideWorldImporters.Warehouse.StockItemStockGroups ssg
INNER Join WideWorldImporters.Warehouse.StockGroups sg
ON ssg.StockGroupID = sg.StockGroupID
INNER join WideWorldImporters.Warehouse.StockItems s
ON ssg.StockItemID = s.StockItemID
INNER join WideWorldImporters.Sales.OrderLines ol
ON ol.StockItemID = s.StockItemID
INNER join WideWorldImporters.Purchasing.PurchaseOrderLines pol
ON pol.StockItemID = s.StockItemID
GROUP BY sg.StockGroupID,sg.StockGroupName;


/* Q14 */

SELECT ct.CityName as cityName,
s.StockItemID as StockItemID,
s.StockItemName as StockItemName,  
sum(ol.Quantity) as TotalQuantity
FROM WideWorldImporters.Application.Cities ct
join WideWorldImporters.Sales.Customers c
on ct.CityID = c.DeliveryCityID
join WideWorldImporters.Sales.Orders o 
on c.CustomerID = o.CustomerID
join WideWorldImporters.Sales.OrderLines ol
on o.OrderID = ol.OrderID
join WideWorldImporters.Warehouse.StockItems s
on ol.StockItemID = s.StockItemID
WHERE o.OrderDate like '2016%'
GROUP BY s.StockItemID, s.StockItemName, ct.CityName
ORDER By ct.CityName, TotalQuantity DESC;

/* Q15 */Not Completed

SELECT * FROM WideWorldImporters.Sales.Invoices;


/* Q16 */

SELECT * FROM WideWorldImporters.Warehouse.StockItems
WHERE JSON_VALUE(CustomFields, '$.CountryOfManufacture') = 'China';


/* Q17 */

SELECT JSON_VALUE(CustomFields, '$.CountryOfManufacture') AS CountryOfManufacture,
SUM(ol.Quantity) AS TotalQuantityStockSold
FROM WideWorldImporters.Sales.Orders o
join WideWorldImporters.Sales.OrderLines ol
on o.OrderID = ol.OrderID
join WideWorldImporters.Warehouse.StockItems s
on ol.StockItemID = s.StockItemID
WHERE o.OrderDate like '2015%'
GROUP By JSON_VALUE(CustomFields, '$.CountryOfManufacture');

/* Q18 */

CREATE VIEW V_ABC AS
SELECT DATEPART(year,o.OrderDate) as YearSold,
sg.StockGroupID,sg.StockGroupName, 
SUM(ol.Quantity) as TotalQuantity
FROM WideWorldImporters.Warehouse.StockGroups sg
join WideWorldImporters.Warehouse.StockItemStockGroups sisg
on sg.StockGroupID = sisg.StockGroupID
join WideWorldImporters.Warehouse.StockItems si
on si.StockItemID = sisg.StockItemID
join WideWorldImporters.Sales.OrderLines ol
on si.StockItemID = ol.StockItemID
join WideWorldImporters.Sales.Orders o
on ol.OrderID = o.OrderID
WHERE DATEPART(year,o.OrderDate) IN (2013,2014,2015,2016,2017)
GROUP By DATEPART(year,o.OrderDate),sg.StockGroupID,sg.StockGroupName;

/* Q19 */
