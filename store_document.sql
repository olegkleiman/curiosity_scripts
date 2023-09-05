CREATE PROCEDURE [dbo].[storeDocument]
	@doc nvarchar(max),
	@title nvarchar(max),
	@url nvarchar(max)
AS
	insert into [dbo].[site_docs]
	(doc, title, url)
	values(@doc, @title, @url)

	return SCOPE_IDENTITY()
GO
