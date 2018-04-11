/*	TEST QUESTION 6

		Create a new stored procedure called [dbo].[SalesOrdersDataReview] with no parameters.

			a.	We need to verify the software that populated the tables [Sales].[SalesOrderHeader]
				and [Sales].[SalesOrderDetail] did so accurately.  Please write SQL in this stored procedure
				that will compare the Subtotal field for [Sales].[SalesOrderHeader] to the sum of the
				LineTotal field for  [Sales].[SalesOrderDetail].  

			b.	You can create as many SQL statements or temp tables as you need, but the end goal is
				to a final result showing a list of all orders with columns; SalesOrderID, SalesOrderNumber,
				OriginalSubtotal, CalculatedSubtotalFromDetail, Difference.

*/


USE AdventureWorks
GO

CREATE PROCEDURE dbo.SalesOrdersDataReview
AS
	SELECT
		SH.SalesOrderID
	   ,SalesOrderNumber
	   ,SubTotal AS OriginalSubtotal
	   ,SUM(LineTotal) AS CalculatedSubtotalFromDetail
	   ,DIFFERENCE(SUM(SD.LineTotal), SH.SubTotal) AS Difference
	FROM Sales.SalesOrderHeader SH
		INNER JOIN Sales.SalesOrderDetail SD
			ON SH.SalesOrderID = SD.SalesOrderID
	WHERE DIFFERENCE('CalculatedSubtotalFromDetail', 'Difference') > 0
	GROUP BY SH.SalesOrderID
		,SalesOrderNumber
		,SubTotal
GO

EXEC dbo.SalesOrdersDataReview
GO
