/*	TEST QUESTION 6

		Create a new stored procedure called [dbo].[SalesOrdersDataReview] with no parameters.

			a.	We need to verify the software that populated the tables [Sales].[SalesOrderHeader]
				and [Sales].[SalesOrderDetail] did so accurately.  Please write SQL in this stored procedure
				that will compare the Subtotal field for [Sales].[SalesOrderHeader] to the sum of the
				LineTotal field for [Sales].[SalesOrderDetail].  

			b.	You can create as many SQL statements or temp tables as you need, but the end goal is
				to a final result showing a list of all orders with columns; SalesOrderID, SalesOrderNumber,
				OriginalSubtotal, CalculatedSubtotalFromDetail, Difference.


	GENERAL COMMENTS
		
		Will re-approach this using the EXCEPT function, which I just discovered.
		https://docs.microsoft.com/en-us/sql/t-sql/language-elements/set-operators-except-and-intersect-transact-sql

*/


USE AdventureWorks
GO

ALTER PROCEDURE dbo.SalesOrdersDataReviewCorrected
AS
	SELECT
		SH.SalesOrderID
	   ,SH.SalesOrderNumber
	   ,ROUND(SH.SubTotal,2) AS OriginalSubtotal
	   --	Remove trailing zeroes from decimal
	   --	Source: https://stackoverflow.com/questions/2938296/remove-trailing-zeros-from-decimal-in-sql-server?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
	   ,CAST(ROUND(SUM(SD.LineTotal),2) AS DECIMAL(9,2)) AS CalculatedSubtotalFromDetail
	   ,SUM(SD.LineTotal)-SH.SubTotal AS Difference
	FROM Sales.SalesOrderHeader SH
		JOIN Sales.SalesOrderDetail SD
			ON SH.SalesOrderID = SD.SalesOrderID
	GROUP BY
		 SH.SalesOrderID
/*	When I don't put SalesOrderNumbrer and SubTotal in the GROUP BY clause, I get the following error:
	"Column 'Sales.SalesOrderHeader.SalesOrderNumber' is invalid in the select list because it is 
	not contained in either an aggregate function or the GROUP BY clause."	*/
		,SH.SalesOrderNumber
		,SH.SubTotal

/* If I want to see all rows */
--	ORDER BY
--		Difference DESC

/* If I only want to see the problem rows */
--	HAVING
--		SUM(SD.LineTotal)-SH.SubTotal >= .1
					
GO

EXEC dbo.SalesOrdersDataReviewCorrected
GO



/*	FIRST ATTEMPT	*/
/*
ALTER PROCEDURE dbo.SalesOrdersDataReview
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
	WHERE DIFFERENCE(SUM(LineTotal), 'SubTotal')  0
	GROUP BY
		 SH.SalesOrderID

		,SalesOrderNumber	
		,SubTotal;		
								
GO

EXEC dbo.SalesOrdersDataReview
GO
*/
