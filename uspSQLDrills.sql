USE AdventureWorks
GO

==============================================
-- Drop stored procedure if it already exists.
==============================================
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'dbo'
     AND SPECIFIC_NAME = N'SQLDrills
)
   DROP PROCEDURE dbo.SQLDrills
GO

==========================
-- Create stored procedure
==========================
CREATE PROCEDURE dbo.SQLDrills
/* Testing answer from bonskijr
https://dba.stackexchange.com/questions/201623/ssms-query-variables-from-table-design-mode-column-description
*/

--"WITH" means:
;WITH src
AS (
    --#1 get extended info description meta attribute
    SELECT sys.objects.name                AS TableName,
           sys.columns.name                AS ColumnName,
           ep.name                         AS PropertyName,
           --"CAST" means:
           CAST(ep.value AS NVARCHAR(255)) AS Description
    FROM sys.objects
        INNER JOIN sys.columns ON sys.objects.object_id = sys.columns.object_id
        --"CROSS APPLY" means:
        CROSS APPLY fn_listextendedproperty(
                                               DEFAULT,
                                               'SCHEMA',
                                               SCHEMA_NAME(schema_id),
                                               'TABLE',
                                               sys.objects.name,
                                               'COLUMN',
                                               sys.columns.name
                                           ) ep --"ep" means:
    WHERE sys.objects.name = 'SalesOrderHeader' AND
          sys.columns.name = 'Status'
),

src2 AS (
   --#2 Retain only status description to be extracted later
   SELECT SUBSTRING(src.Description, CHARINDEX('.', src.Description) + 1, 255) descd 
   FROM src
 )
   --#3 extract id and description
SELECT CAST(SUBSTRING(x.StatusDesc, 1, CHARINDEX('=', x.StatusDesc) - 1) AS TINYINT) AS StatusId,
       --"LTRIM" and "RTRIM" mean:
       LTRIM(RTRIM(SUBSTRING(x.StatusDesc, CHARINDEX('=', x.StatusDesc) + 1, 255)))  AS StatusDesc
FROM
(
    SELECT LTRIM(RTRIM(m.n.value('.[1]', 'varchar(8000)'))) AS StatusDesc
    FROM
    (
        --#3.1 generate rows from the delimited data of status description
        SELECT CAST('<XMLRoot><RowData>' + REPLACE(src2.descd, ';', '</RowData><RowData>') + '</RowData></XMLRoot>' AS XML) AS x
        FROM src2
    )                                           t
        CROSS APPLY x.nodes('/XMLRoot/RowData') m(n)
) x;
GO

===========================
-- Execute stored procedure
===========================
EXEC dbo.SQLDrills
GO
