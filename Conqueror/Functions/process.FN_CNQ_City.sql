CREATE FUNCTION [process].[FN_CNQ_City]
(
	@City nvarchar(100)
)
RETURNS nvarchar(100)
AS
BEGIN
	-- Ignoramos lo que está tras las comas en City (incluidos estados USA)
	IF ISNULL(CHARINDEX(',',@City,1),0) > 0
		RETURN SUBSTRING(@City,1,CHARINDEX(',',@City,1)-1)

	RETURN @City

END
