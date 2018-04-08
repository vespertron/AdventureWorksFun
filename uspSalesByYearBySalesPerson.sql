Use AdventureWorks
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.SalesYearBySalesPerson
AS
BEGIN
	SET NOCOUNT ON;

	--Return sales by sales person by year: (Existing vSalesPersonSalesByFiscalYear did most of my work for me, so I'll include addt'l insights below this one)
	SELECT
		 pvt.[SalesPersonID]
		,pvt.[FullName]
		,pvt.[JobTitle]
		,pvt.[SalesTerritory]
		,ROUND(pvt.[2011], 2) AS '2011'
		,ROUND(pvt.[2012], 2) AS '2012'
		,ROUND(pvt.[2013], 2) AS '2013'
		,ROUND(pvt.[2014], 2) AS '2014'
	FROM	(SELECT
				soh.[SalesPersonID]
				,p.[FirstName] + ' ' + COALESCE(p.[MiddleName], '') + ' ' + p.[LastName] AS [FullName]
				,e.[JobTitle]
				,st.[Name] AS [SalesTerritory]
				,soh.[SubTotal]  --sales value
				,YEAR(DATEADD(m, 6, soh.[OrderDate])) AS [FiscalYear]
			 FROM	[Sales].[SalesPerson] sp
				INNER JOIN	[Sales].[SalesOrderHeader] soh
					ON sp.[BusinessEntityID] = soh.[SalesPersonID]
				INNER JOIN	[Sales].[SalesTerritory] st
					ON sp.[TerritoryID] = st.[TerritoryID]
				INNER JOIN	[HumanResources].[Employee] e
					ON soh.[SalesPersonID] = e.[BusinessEntityID]
				INNER JOIN	[Person].[Person] p
					ON p.[BusinessEntityID] = sp.[BusinessEntityID]) AS soh
	PIVOT
		(
		SUM([SubTotal]) FOR [FiscalYear] IN ([2011], [2012], [2013], [2014])
		) AS pvt;
	
		
	--Return sales by territory and # sales people by year:
	SELECT
		 pvt.SalesTerritory
		,COUNT(pvt.SalesPersonID) AS SalesPeople
		,ROUND(SUM(pvt.[2011]), 2) AS '2011'
		,ROUND(SUM(pvt.[2012]), 2) AS '2012'
		,ROUND(SUM(pvt.[2013]), 2) AS '2013'
		,ROUND(SUM(pvt.[2014]), 2) AS '2014'
		--What's the best (including OOPMAXiest) way to take the average sales per territory per person here? 
	FROM    (SELECT
				st.[Name] AS [SalesTerritory]
				,soh.[SalesPersonID]
				,soh.[SubTotal]
				,YEAR(DATEADD(m, 6, soh.[OrderDate])) AS [FiscalYear]
			 FROM   [Sales].[SalesPerson] sp
				INNER JOIN  [Sales].[SalesOrderHeader] soh
					ON sp.[BusinessEntityID] = soh.[SalesPersonID]
				INNER JOIN  [Sales].[SalesTerritory] st
					ON sp.[TerritoryID] = st.[TerritoryID]
				INNER JOIN  [HumanResources].[Employee] e
					ON soh.[SalesPersonID] = e.[BusinessEntityID]
				INNER JOIN  [Person].[Person] p
					ON p.[BusinessEntityID] = sp.[BusinessEntityID]) AS soh
	PIVOT
		(
		SUM([SubTotal]) FOR [FiscalYear] IN ([2011], [2012], [2013], [2014])
		) AS pvt
	GROUP BY    pvt.SalesTerritory;


	--Unpivot year, then pivot territory:			--Will come back to this later
/*	SELECT
		 FiscalYear
		,[Australia]
		,[Canada]
		,[Central]
		,[France]
		,[Germany]
		,[Northeast]
		,[Northwest]
		,[Southeast]
		,[Southwest]
		,[United Kingdom]
	FROM
		(
		Select FiscalYear, 
*/		 



END
GO

EXEC dbo.SalesYearBySalesPerson