USE AdventureWorks
GO

==============================================
-- Drop stored procedure if it already exists.
==============================================
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'dbo'
     AND SPECIFIC_NAME = N'SalesOrdersDataReview'
)
   DROP PROCEDURE dbo.SalesOrdersDataReview
GO

==========================
-- Create stored procedure
==========================
CREATE PROCEDURE dbo.SalesOrdersDataReview
AS

GO

============================
-- Execute stored procedure.
============================
EXECUTE dbo.SalesOrdersDataReview
GO
