/*	TEST QUESTION 3

		Create a SQL statement to select the following column names:

		a.	SalesOrderID,RevisionNumber,OrderDate,OrderStatusText,SalesOrderNumber,
			SubTotal,TaxAmt,Freight,TotalDue,OrderQtyText,UnitPrice,UnitPriceDiscount,
			LineTotal,ShipToCity,ShipToState,ShipToZip,ShipToCountryCode,ShipToCountryName,
			ModelName,CategoryName

				i.		OrderStatusText is a translated column that notes what the OrderStatusID means.

				ii.		OrderQtyText is the order quantity but with leading zeros that forces the value
						to 4 characters wide.

				iii.	The rest of the columns closely match the database fields.

				iv.		Note the tables used will focus on [Sales].[SalesOrderHeader]
						and [Sales].[SalesOrderDetail] but to get the rest of the columns you will need
						to join to six additional tables.

		b.	Select the top 100 records. Sort by SalesOrderNumber.
 */



/*	Format reasoning: multiple SQL developers have advised me to use double spaces
	because,
		"... spaces are literal and tabs are not, i.e. tabs are not consistent amongst editors.
	They generally represent 4 spaces, although I have seen them represented with as many as 7 spaces.
	That said, most senior developers use spaces to preserve formatting." -Lyle Bowe
*/


SELECT top 100
  SH.SalesOrderID
  ,SH.RevisionNumber
  ,SH.OrderDate
  ,SS.Status AS OrderStatusText -- custom table
  ,SH.SalesOrderNumber
  ,SH.SubTotal
  ,SH.TaxAmt
  ,SH.Freight
  ,SH.TotalDue
--	OrderQtyText: how to add zeroes to front of integer https://stackoverflow.com/questions/16760900/pad-a-string-with-leading-zeros-so-its-3-characters-long-in-sql-server-2008?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
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

--	Sales.SalesOrderStatus is a table which I created for the description of status for "OrderStatusText" column.
--	https://dba.stackexchange.com/questions/201623/ssms-query-variables-from-table-design-mode-column-description?stw=2
  
  JOIN Sales.SalesOrderStatus SS ON SH.Status = SS.StatusID
  JOIN Sales.SalesOrderDetail SD ON SH.SalesOrderID = SD.SalesOrderID
  JOIN Person.Address PA ON SH.ShipToAddressID = PA.AddressID
  JOIN Person.vStateProvinceCountryRegion PSC ON PA.StateProvinceID = PSC.StateProvinceID
  JOIN Production.Product PP ON SD.ProductID = PP.ProductID
  JOIN Production.ProductModel PM ON PP.ProductModelID = PM.ProductModelID
  JOIN Production.ProductSubcategory PS ON PP.ProductSubcategoryID = PS.ProductSubcategoryID
  JOIN Production.ProductCategory PC ON PS.ProductCategoryID = PC.ProductCategoryID
ORDER BY SalesOrderNumber