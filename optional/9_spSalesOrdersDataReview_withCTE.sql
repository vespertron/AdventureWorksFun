USE AdventureWorks
GO

CREATE PROCEDURE dbo.SalesOrdersDataReviewCTE
AS
 ;WITH SH AS
	(
	SELECT
		 SH.SalesOrderID
		,SH.SalesOrderNumber
		,SH.SubTotal
	FROM Sales.SalesOrderHeader SH
	), SD AS
	(
	SELECT
		 SD.SalesOrderID
		,SD.LineTotal
	FROM Sales.SalesOrderDetail SD
	)

	SELECT
		SH.SalesOrderID
	   ,SH.SalesOrderNumber
	   ,SH.SubTotal AS OriginalSubtotal
	   ,SUM(SD.LineTotal) AS CalculatedSubtotalFromDetail
	   ,DIFFERENCE(SUM(SD.LineTotal), SH.SubTotal) AS Difference
	FROM SH, SD
	WHERE SD.SalesOrderID = SH.SalesOrderID
		AND
			DIFFERENCE('CalculatedSubtotalFromDetail', 'Difference') > 0
	GROUP BY SH.SalesOrderID;

GO

EXEC dbo.SalesOrdersDataReview
GO
