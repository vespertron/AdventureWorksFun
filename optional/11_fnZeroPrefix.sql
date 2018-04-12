USE AdventureWorks
GO

CREATE FUNCTION dbo.ufnZeroPrefix(
	 @Number INT
	,@Size INT
) 
RETURNS NVARCHAR(MAX)
WITH SCHEMABINDING
AS 
BEGIN

RETURN REPLICATE('0',@Size-LEN(RTRIM(CONVERT(NVARCHAR(MAX),@Number))))
		+ CONVERT(NVARCHAR(MAX),@Number)

END;


/* Alternatively: Add input parameter @Length to existing ufnLeadingZeros from AdventureWorks,
then replace length number with @Length variable.

Replace VARCHAR(8) with NVARCHAR(MAX) in case user wants to return the entire length of Pi or something equally ambitious */
ALTER FUNCTION [dbo].[ufnLeadingZerosCopy](
    @Value int,
	@Length int
) 
RETURNS nvarchar(max) 
WITH SCHEMABINDING 
AS 
BEGIN
    DECLARE @ReturnValue nvarchar(max);

    SET @ReturnValue = CONVERT(nvarchar(max), @Value);
    SET @ReturnValue = REPLICATE('0', @Length - DATALENGTH(@ReturnValue)) + @ReturnValue;

    RETURN (@ReturnValue);
END;

SELECt dbo.LeadingZeros1 ('5', '10')

SELECT dbo.ufnZeroPrefix('5309', '10')