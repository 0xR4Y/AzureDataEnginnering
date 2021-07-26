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

/* Q11 */
--Not Completed

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

/* Q15 */
--Not Completed

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
--Note: Order doest not work with View

CREATE VIEW V_TotalStockGroupByYearOrderByName AS
SELECT sg.StockGroupName, 
DATEPART(year,o.OrderDate) as YearSold,
SUM(ol.Quantity) as TotalQuantity
FROM WideWorldImporters.Warehouse.StockGroups sg
inner join WideWorldImporters.Warehouse.StockItemStockGroups sisg
on sg.StockGroupID = sisg.StockGroupID
inner join WideWorldImporters.Warehouse.StockItems si
on si.StockItemID = sisg.StockItemID
inner join WideWorldImporters.Sales.OrderLines ol
on si.StockItemID = ol.StockItemID
inner join WideWorldImporters.Sales.Orders o
on ol.OrderID = o.OrderID
WHERE DATEPART(year,o.OrderDate) IN (2013,2014,2015,2016,2017)
GROUP By sg.StockGroupName,DATEPART(year,o.OrderDate);
--ORDER BY sg.StockGroupName,DATEPART(year,o.OrderDate);

/* Q19 */ 

CREATE VIEW V_TotalStockGroupByYearOrderByYear AS
SELECT DATEPART(year,o.OrderDate) as YearSold,sg.StockGroupName, 
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
GROUP By sg.StockGroupName,DATEPART(year,o.OrderDate)
--ORDER BY DATEPART(year,o.OrderDate),sg.StockGroupName;

/* Q20 */

CREATE FUNCTION dbo.GetTotalOrder(@OrderID int)
returns decimal(18,2)
as 
Begin
declare @TotalOrder decimal(18,2)
SELECT @TotalOrder = SUM(s.RecommendedRetailPrice* ol.Quantity) FROM 
	WideWorldImporters.Sales.Orders o
	INNER Join WideWorldImporters.Sales.OrderLines ol
	ON o.OrderID = ol.OrderID
	INNER join WideWorldImporters.Warehouse.StockItems s
	ON ol.StockItemID=s.StockItemID
	WHERE o.OrderID = @OrderID
	GROUP BY o.OrderID
return @TotalOrder
end

--Attach Total Order to Invoices table
SELECT *, dbo.GetTotalOrder(OrderID) as TotalOrder
FROM WideWorldImporters.Sales.Invoices ;

--DROP FUNCTION GetTotalOrder;

--SELECT o.OrderID,
--SUM(s.RecommendedRetailPrice* ol.Quantity) As TotalOrder
--FROM WideWorldImporters.Sales.Orders o
--INNER Join WideWorldImporters.Sales.OrderLines ol
--ON o.OrderID = ol.OrderID
--INNER join WideWorldImporters.Warehouse.StockItems s
--ON ol.StockItemID=s.StockItemID
--GROUP BY o.OrderID
--Order By o.OrderID

/* Q21 */
USE ods
GO

--Creating Table
--CREATE TABLE Orders(
--    OrderID Int NOT NULL,
--    OrderDate Date,
--    OrderTotal decimal(18,2),
--    CustomerID Int,
--	PRIMARY KEY (OrderID),
--);


CREATE Procedure TotalOrderDate @Date Date
AS
Begin TRY 
	Begin Transaction;
		INSERT INTO Orders(OrderId,OrderDate,OrderTotal,CustomerID)
		SELECT o.OrderID,o.OrderDate, SUM(ol.Quantity*ol.UnitPrice) AS TotalOrder,o.CustomerID 
		FROM WideWorldImporters.Sales.Orders o
		INNER Join WideWorldImporters.Sales.OrderLines ol
		On  o.OrderID=ol.OrderID
		Group By o.OrderID,o.OrderDate,o.CustomerID 
		Having o.OrderDate = @Date
		Commit Transaction;
End Try
Begin Catch
	rollback transaction
End Catch

--INSERT INTO Orders(OrderId,OrderDate,OrderTotal,CustomerID)
--	SELECT o.OrderID,o.OrderDate, SUM(ol.Quantity*ol.UnitPrice) AS TotalOrder,o.CustomerID 
--	FROM WideWorldImporters.Sales.Orders o
--	INNER Join WideWorldImporters.Sales.OrderLines ol
--	On  o.OrderID=ol.OrderID
--	Group By o.OrderID,o.OrderDate,o.CustomerID 
--	Having o.OrderDate = '2013-01-01'


--DELETE Orders WHERE OrderDate = '2013-01-01';
SELECT * FROM Orders;

--EXEC
EXEC dbo.TotalOrderDate @Date = '2013-01-01';

/* Q22*/

select StockItemID, StockItemName, SupplierID, ColorID, UnitPackageID, OuterPackageID, Brand, 
Size, LeadTimeDays, QuantityPerOuter, IsChillerStock, Barcode, TaxRate, UnitPrice, 
RecommendedRetailPrice, TypicalWeightPerUnit, MarketingComments, InternalComments, 
JSON_VALUE(CustomFields,'$.CountryOfManufacture') CountryOfManufacture,
JSON_VALUE(CustomFields,'$.Range') 'Range',
datediff(DAYOFYEAR, ValidFrom, ValidTo) Shelflife
into ods.dbo.StockItems
from WideWorldImporters.Warehouse.StockItems

SELECT * FROM ods.dbo.StockItems

/* Q23 */
USE ods
GO

CREATE Procedure TotalOrderDate23 @Date Date
AS
Begin TRY 
	Begin Transaction;
		delete from ods.dbo.Orders where OrderDate < @Date
		INSERT INTO Orders(OrderId,OrderDate,OrderTotal,CustomerID)
		SELECT o.OrderID,o.OrderDate, SUM(ol.Quantity*ol.UnitPrice) AS TotalOrder,o.CustomerID 
		FROM WideWorldImporters.Sales.Orders o
		INNER Join WideWorldImporters.Sales.OrderLines ol
		On  o.OrderID=ol.OrderID
		Group By o.OrderID,o.OrderDate,o.CustomerID 
		Having o.OrderDate >= @Date and o.OrderDate <= DATEADD(day,7, @Date) 
		Commit Transaction;
End Try
Begin Catch
	rollback transaction
End Catch

EXEC dbo.TotalOrderDate23 @Date = '2016-03-01';
SELECT * FROM ods.dbo.Orders;
