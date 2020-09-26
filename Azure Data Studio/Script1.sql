-- you can run selected text with F5

USE AdventureWorks2017;
GO

-- Run the following statement and check the different export/chart options
-- save the results as .csv file and check the replace options
SELECT TOP 10
    SalesOrderID,
    SalesOrderDetailID,
    CarrierTrackingNumber,
    OrderQty,
    ProductID,
    UnitPrice,
    UnitPriceDIscount,
    LineTotal,
    ModifiedDate
    -- give a try to the autocomplete feature
    
FROM Sales.SalesOrderDetail SD;
-- copy a couple of columns (using SHIFT key) from the above results and copy them to excel file


-- Try the 'Peek Definition' option over the following view:

SELECT TOP 10 * FROM [HumanResources].[vEmployee]

-- Try the 'Go to definition' option over the following Stored Procedure (press F12):

EXEC uspGetEmployeeManagers 3



-- You can also generate estimated and actual execution plans
-- For estimated plan, just select the query and click the "Explain" option
-- For actual plan, select the query and from the command palette, select "Run current query with actual plan" option
SELECT 
	WorkOrderID,
	EndDate,
	OrderQty,
	COUNT(WorkOrderID) OVER(PARTITION BY EndDate ORDER BY WorkOrderID) as NumOrdersByDay,
	SUM(OrderQty) OVER(PARTITION BY EndDate ORDER BY WorkOrderID) as ItemsOrderedByDay
FROM [Production].[WorkOrder] 
WHERE EndDate < 'Jul 01, 2011'
ORDER BY EndDate;



-- Format the following query using the Command Palette options (F1 and type Format, then select Format Selection)
-- You can see the automatic format is not perfect, try again with the PoorSQL extension

SeLeCt          d.LineTotal
, d.ModifiedDate 
    as [Mod Date], d.UnitPrice,      d.OrderQty 
aS
     [Quantity]
    from    Sales.SalesOrderDetail D wHErE d.OrderQty 
    >1
    ;


