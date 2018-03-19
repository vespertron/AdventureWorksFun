USE AdventureWorks
GO

==============================================
-- Drop stored procedure if it already exists.
==============================================
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'dbo'
     AND SPECIFIC_NAME = N'XMLFun'
)
   DROP PROCEDURE dbo.XMLFun
GO

==========================
-- Create stored procedure
==========================
CREATE PROCEDURE dbo.XMLFun
AS

GO

============================
-- Execute stored procedure.
============================
EXECUTE dbo.XMLFun
GO
