USE AdventureWorks
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.Filter
	@jobtitle1 nvarchar(30), 
	@jobtitle2 nvarchar(30) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @search nvarchar(MAX)

	SET @jobtitle1 = RTRIM(LTRIM(@jobtitle1))
	SET @jobtitle2 = ' ' + RTRIM(LTRIM(@jobtitle2))

	IF @jobtitle2 IS NULL  -- scenario 1 - we don't have second input parameter - 1 single word search
		BEGIN
			SET @search = '%' + @jobtitle1 + '%'

		END

		ELSE -- if we have scenario 2 and have the second parameter as search word - 2 search words
			BEGIN
				SET @search = '%' + @jobtitle1 + @jobtitle2 + '%'
			END

	DECLARE @dynamic nvarchar(max)
	SET @dynamic = 'SELECT	JobTitle
							,COUNT(CASE WHEN Gender = ''M'' THEN 1 END) as Male
							,COUNT(CASE WHEN Gender = ''F'' THEN 1 END) as Female
					FROM HumanResources.Employee
					WHERE HumanResources.Employee.JobTitle LIKE @searchParam
					GROUP BY JobTitle'

	EXEC sp_executesql @dynamic, N'@searchParam nvarchar(100)', @searchParam = @search
	
END
GO

EXEC dbo.Filter '   DESIGN   '
EXEC dbo.Filter '   DESIGN   ' , '   Engineer   '