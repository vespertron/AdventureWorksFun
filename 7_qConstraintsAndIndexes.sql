/*	TEST QUESTION  7
		For the tables you are working with be prepared
		to explain what primary and foreign keys are used
		and also note what columns have indexes.


	GENERAL COMMENTS

		Next steps:
		1.	combine queries to select PK, FK, and Index columns (check that it's a good idea first)
		2.	add commented-out filters to easily query the tables I've been working with
		3.	make sure I understand what's happening in these queries
*/


USE AdventureWorks
GO


/*	PRIMARY KEYS
	https://stackoverflow.com/questions/6108697/get-a-list-of-all-primary-keys-in-a-database?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa */

SELECT i.name AS IndexName, OBJECT_NAME(ic.OBJECT_ID) AS TableName, 
       COL_NAME(ic.OBJECT_ID,ic.column_id) AS ColumnName
FROM sys.indexes AS i
INNER JOIN sys.index_columns AS ic
ON i.OBJECT_ID = ic.OBJECT_ID
AND i.index_id = ic.index_id
WHERE i.is_primary_key = 1


/*	FOREIGN KEYS
	https://www.mssqltips.com/sqlservertip/5004/script-to-identify-all-nonindexed-foreign-keys-in-a-sql-server-database/ */

	WITH v_NonIndexedFKColumns AS (
   SELECT 
      Object_Name(a.parent_object_id) AS Table_Name
      ,b.NAME AS Column_Name
   FROM 
      sys.foreign_key_columns a
      ,sys.all_columns b
      ,sys.objects c
   WHERE 
      a.parent_column_id = b.column_id
      AND a.parent_object_id = b.object_id
      AND b.object_id = c.object_id
      AND c.is_ms_shipped = 0
   EXCEPT
   SELECT 
      Object_name(a.Object_id)
      ,b.NAME
   FROM 
      sys.index_columns a
      ,sys.all_columns b
      ,sys.objects c
   WHERE 
      a.object_id = b.object_id
      AND a.key_ordinal = 1
      AND a.column_id = b.column_id
      AND a.object_id = c.object_id
      AND c.is_ms_shipped = 0
   )
SELECT 
   v.Table_Name AS NonIndexedCol_Table_Name
   ,v.Column_Name AS NonIndexedCol_Column_Name             
   ,fk.NAME AS Constraint_Name   
   ,SCHEMA_NAME(fk.schema_id) AS Ref_Schema_Name       
   ,object_name(fkc.referenced_object_id) AS Ref_Table_Name      
   ,c2.NAME AS Ref_Column_Name         
FROM 
   v_NonIndexedFKColumns v
   ,sys.all_columns c
   ,sys.all_columns c2
   ,sys.foreign_key_columns fkc
   ,sys.foreign_keys fk
WHERE 
   v.Table_Name = Object_Name(fkc.parent_object_id)
   AND v.Column_Name = c.NAME
   AND fkc.parent_column_id = c.column_id
   AND fkc.parent_object_id = c.object_id
   AND fkc.referenced_column_id = c2.column_id
   AND fkc.referenced_object_id = c2.object_id
   AND fk.object_id = fkc.constraint_object_id
ORDER BY 1,2


/*	INDEXES 
	https://stackoverflow.com/questions/765867/list-of-all-index-index-columns-in-sql-server-db?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa */

SELECT 
     TableName = t.name,
     IndexName = ind.name,
     IndexId = ind.index_id,
     ColumnId = ic.index_column_id,
     ColumnName = col.name,
     ind.*,
     ic.*,
     col.* 
FROM 
     sys.indexes ind 
INNER JOIN 
     sys.index_columns ic ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN 
     sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN 
     sys.tables t ON ind.object_id = t.object_id 
WHERE 
     ind.is_primary_key = 0 
     AND ind.is_unique = 0 
     AND ind.is_unique_constraint = 0 
     AND t.is_ms_shipped = 0 
ORDER BY 
     t.name, ind.name, ind.index_id, ic.index_column_id;

