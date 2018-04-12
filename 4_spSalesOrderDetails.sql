/*	TEST QUESTION 4
	
		Create a stored procedure called [dbo].[SalesOrderDetails] that will use the SQL
		prepared above and use two parameters to filter the results by a
		beginning and ending Order date.  Create commented out SQL that can execute tests
		executes inside the stored procedure using the /* and */ notation for comments.
		This way it is easy to easy to input different dates and view the data result output
		from using this commented out sql.

	GENERAL COMMENTS

		I used dashes for test comments so they can be easily tested one at a time without deleting
		bookend comment code.
		
*/


/*
USE AdventureWorks
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SalesOrderDetails] 

	--	Set input param defaults to NULL so that proc executes with or without user input
	--	https://technet.microsoft.com/en-us/library/ms189330(v=sql.105).aspx
    @BeginDate DATE = NULL,
    @EndDate DATE = NULL

AS
*/

/*	TEST INPUTS */

		EXEC dbo.SalesOrderDetails 

/*	DATE FORMAT */
			--	@BeginDate = '1/1/00',			@EndDate = '12/31/15'			--Query executed successfully.
			--	@BeginDate = '1MAR13',			@EndDate = '30APR13				--Query executed successfully.
			--	@BeginDate = '1 May 13',		@EndDate = '30 June 14'			--Query executed successfully.
			--	@BeginDate = '1 Jul 2013',		@EndDate = '31 Aug 2013'		--Query executed successfully.
			--	@BeginDate = '01 Oct 2013',		@EndDate = '31 Oct 2014'		--Query executed successfully.
			--	@BeginDate = '1 March 14',		@EndDate = '31 March 14'		--Query executed successfully.
			--	@BeginDate = '1May2014',		@EndDate = '31May2014'			--Query executed successfully.
			--	@BeginDate = '1st Oct 2014',	@EndDate = '31st Oct 2014'		--Query executed successfully.
			--	@BeginDate = '30/1/12',			@EndDate = '30/2/12'			--Error converting data type varchar to date.
			--	@BeginDate = 'May 3 2008',		@EndDate = 'May 10 2008'		--Query executed successfully.
			--	@BeginDate = 'May 3rd 2008',	@EndDate = 'May 10th 2008'		--Error converting data type varchar to date.

/*	MIXED FORMATS */
			--	@BeginDate = '11/1/11',			@EndDate = '31 Dec 2012'		--Query executed successfully.
			--	@BeginDate = '1 May 13',		@EndDate = '30/Jun/14'			--Query executed successfully.
			--	@BeginDate = '1stOct2014',		@EndDate = '31Oct 2014'			--Error converting data type varchar to date.

/*	WRONG DATA TYPE */
			--	@BeginDate = '32MAR13',			@EndDate = '31APR13'			--Error converting data type varchar to date.
			--	@BeginDate = 'birthday',		@EndDate = 'unbirthday'			--Error converting data type varchar to date.

/*	WILDCARDS, MISSPELLING, MISSING CHARACTERS */
			--	@BeginDate = '1/12',			@EndDate = '2/12'				--Error converting data type varchar to date.
			--	@BeginDate = '1/2012',			@EndDate = '2/2012'				--Error converting data type varchar to date.	
			--	@BeginDate = '%/14',			@EndDate = '%/14'				--Error converting data type varchar to date.
			--	@BeginDate = '* /13',			@EndDate = '* /13'				--Error converting data type varchar to date.
			--	@BeginDate = '1/ * /12',		@EndDate = '2/ * /12'			--Error converting data type varchar to date.	
			--	@BeginDate = '1MOY13',			@EndDate = '30MOY13'			--Error converting data type varchar to date.

		
/*
BEGIN
SET NOCOUNT ON;

SET @BeginDate = ISNULL(@BeginDate, GETDATE())
SET @EndDate = ISNULL(@EndDate, GETDATE())
  
SELECT top 100
	 SH.SalesOrderID
	,SH.RevisionNumber
	,SH.OrderDate
	,SS.Status AS OrderStatusText
	,SH.SalesOrderNumber
	,SH.SubTotal
	,SH.TaxAmt
	,SH.Freight
	,SH.TotalDue
	--	convert INT to STRING with 4 characters
	--	https://stackoverflow.com/questions/16760900/pad-a-string-with-leading-zeros-so-its-3-characters-long-in-sql-server-2008?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
	,RIGHT('000' + CONVERT(VARCHAR(4), SD.OrderQty),4) AS OrderQtyText
	,SD.UnitPrice
	,SD.UnitPriceDiscount
	,SD.LineTotal
	,PA.City AS ShipToCity
	,PSC.StateProvinceCode AS ShipToState
	,PA.PostalCode AS ShipToZip
	,PSC.CountryRegionCode AS ShipToCountryCode
	,PSC.CountryRegionName AS ShipToCountryName
	,PM.Name AS ModelName
	,PC.Name AS CategoryName
FROM Sales.SalesOrderHeader SH
	INNER JOIN Sales.SalesOrderStatus SS
		ON SH.Status = SS.StatusID
	INNER JOIN Sales.SalesOrderDetail SD
		ON SH.SalesOrderID = SD.SalesOrderID
	INNER JOIN Person.Address PA
		ON SH.ShipToAddressID = PA.AddressID
	INNER JOIN Person.vStateProvinceCountryRegion PSC
		ON PA.StateProvinceID = PSC.StateProvinceID
	INNER JOIN Production.Product PP
		ON SD.ProductID = PP.ProductID
	INNER JOIN Production.ProductModel PM
		ON PP.ProductModelID = PM.ProductModelID
	INNER JOIN Production.ProductSubcategory PS
		ON PP.ProductSubcategoryID = PS.ProductSubcategoryID
	INNER JOIN Production.ProductCategory PC
		ON PS.ProductCategoryID = PC.ProductCategoryID
WHERE SH.OrderDate BETWEEN @BeginDate AND @EndDate
ORDER BY SalesOrderNumber
END;

EXEC dbo.SalesOrderDetails @BeginDate = '', @EndDate = ''
GO
*/