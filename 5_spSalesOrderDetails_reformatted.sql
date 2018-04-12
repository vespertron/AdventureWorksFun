/*	TEST QUESTION 5

		In your SQL, please adjust the formatting to be similar to the below example.
		Formatting is important to the team since it makes it easier to read if it is consistent.
		Also generously add comment lines with notes and descriptions to help others understand
		important elements of your code.  When joining tables, please always use table aliases 
		like shown below (t1, t2, t3) that represent the table clearly.  Use short alias names
		that are clearly understood.


	GENERAL COMMENTS

		Instead of table aliases t1, t2, t3, I used table acronyms
		so they'd be easier to identify.

		"Bad Habits to Kick Using Table Aliases":
		https://sqlblog.org/2009/10/08/bad-habits-to-kick-using-table-aliases-like-a-b-c-or-t1-t2-t3
*/


SELECT TOP 100
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
	INNER JOIN Sales.SalesOrderStatus SS	-- Custom table
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
ORDER BY SalesOrderNumber;