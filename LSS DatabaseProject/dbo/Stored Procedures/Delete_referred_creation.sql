--USE [LSS]
--GO

--DECLARE	@return_value int

--EXEC	@return_value = [dbo].[Delete_creation_duplicates]

--SELECT	'Return Value' = @return_value

--GO
CREATE Procedure Delete_referred_creation
AS 
 DELETE FROM [LSS].[dbo].[Creation_Reports_Hub_Lab]
 WHERE [Referring_Lab] IS NOT NULL OR [Referring_Lab] != '';