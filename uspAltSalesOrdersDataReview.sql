USE AdventureWorks
GO

==============================================
-- Drop stored procedure if it already exists.
==============================================
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'dbo'
     AND SPECIFIC_NAME = N'AltSalesOrdersDataReview'
)
   DROP PROCEDURE dbo.AltSalesOrdersDataReview
GO

==========================
-- Create stored procedure
==========================
CREATE PROCEDURE dbo.AltSalesOrdersDataReview
AS

GO

============================
-- Execute stored procedure.
============================
EXECUTE dbo.AltSalesOrdersDataReview
GO