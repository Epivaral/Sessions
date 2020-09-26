

/*
	Execute the following query and select the chart option,
	then select the Bar chart type, with Vertical data direction
*/

SELECT 
	YEAR(EndDate) as YEAR,
	COUNT(WorkOrderID)  NumOrders
FROM AdventureWorks2017.[Production].[WorkOrder] 
GROUP BY YEAR(EndDate)
ORDER BY YEAR;

--Select the Create Insight option on the chart pane

-- A new window will open with JSON code containing our snippet
-- Format it
-- open settings and navigate to dashboard > widgets
-- At the end of the file, add  "dashboard.server.widgets" property, a snippet will open with a template, just delete the contents of it
-- add the code previously generated
-- save it
-- test it by right clicking Manage on the active connection