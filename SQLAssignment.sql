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

