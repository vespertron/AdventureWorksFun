# AdventureWorksFun

This is a collection of T-SQL stored procedures using the Microsoft AdventureWorks database https://github.com/Microsoft/sql-server-samples/releases/tag/adventureworks.

## uspSalesOrderDetails.sql
  This stored procedure selects Sales Order Details between input parameters Begin Date and End Date.
  
## uspSalesOrdersDataReview.sql

  This stored procedure is a quality check that compares the Subtotal field for [Sales].[SalesOrderHeader] to the sum of the LineTotal field for  [Sales].[SalesOrderDetail] to ensure that the software which populates these tables did so accurately.
  
  OUTPUT:
  
  SalesOrderID
  
  ,SalesOrderNumber
  
  ,OriginalSubtotal
  
  ,CalculatedSubtotalFromDetail
  
  ,Difference
  
## uspXMLFun.sql

  This stored procedure parses XML to a temp table, then creates XML from that table to look like the original XML using the FOR XML syntax.
  
  The FOR XML is used with the STUFF function to convert a list of a single column to a comma separated value.
