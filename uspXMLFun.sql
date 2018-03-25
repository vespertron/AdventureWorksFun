USE BREAKFAST
GO

CREATE TABLE BreakfastMenu
(
Id INT IDENTITY PRIMARY KEY,
XMLData XML,
LoadedDateTime DATETIME
)

INSERT INTO BreakfastMenu(XMLData, LoadedDateTime)
SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE()
FROM OPENROWSET(BULK 'C:\users\vespe\projects\BreakfastMenu.xml', SINGLE_BLOB) AS x;

SELECT * FROM BreakfastMenu
