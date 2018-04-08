/* demonstrate
	 like operator
	,having clause
	,looping with cursors
	,looping without cursors
	,distinct operator
	,temp tables
	,table variables
	,exists
  in meaningful ways.
 
 They need help directing their sales efforts to go after areas that are showing sales growth.*/


USE AdventureWorks
GO

-- Drop stored procedure if it already exists.
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'dbo'
     AND SPECIFIC_NAME = N'SQLDrills'
)
   DROP PROCEDURE dbo.SQLDrills
GO

CREATE PROC SQLDrills
AS
BEGIN
	SET NOCOUNT ON;



END
GO

EXEC SQLDrills