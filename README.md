# AdventureWorksFun

This is a collection of T-SQL stored procedures using the Microsoft AdventureWorks database https://github.com/Microsoft/sql-server-samples/releases/tag/adventureworks.
If you have any suggestions to improve this code, I'd love your feedback!

## mergeProductVendor.sql
  This script is to merge a new Purchasing.ProductVendorTarget table to the Purchasing.ProductVendor source after the new table is created.

## uspSalesOrderDetails.sql
  This stored procedure selects Sales Order Details between input parameters Begin Date and End Date.
  
## uspSalesOrdersDataReview.sql
  This stored procedure is a quality check that compares the Subtotal field for Sales.SalesOrderHeader to the sum of the LineTotal field for  Sales.SalesOrderDetail to ensure that the software which populates these tables did so accurately.
  
  OUTPUT:
  
  SalesOrderID
  
  ,SalesOrderNumber
  
  ,OriginalSubtotal
  
  ,CalculatedSubtotalFromDetail
  
  ,Difference

## uspAltSalesOrdersDataReview.sql
  This uses a CTE (common table expression) to quality check the Sales.SalesOrderHeader.Subtotal against the Sales.SalesOrderDetail.LineTotal.
  
## uspXMLFun.sql
  This stored procedure parses XML to a temp table, then creates XML from that table to look like the original XML using the FOR XML syntax.
  
  The FOR XML is used with the STUFF function to convert a list of a single column to a comma separated value.

## uspSQLDrills.sql
  This stored procedure is a sandbox to test items such as
- like operator
- having clause
- looping with and without cursors
- distinct operator
- temp tables vs table variables
- exists condition
