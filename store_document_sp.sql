CREATE PROCEDURE [dbo].[storeDocument]
	@doc nvarchar(max),
	@title nvarchar(max),
	@url nvarchar(max),
	@geom_location nvarchar(max)
AS
	insert into [dbo].[site_docs]
	(doc, title, url, [latlong])
	values(@doc, @title, @url, geography::STGeomFromText(@geom_location, 4326))

	return SCOPE_IDENTITY()
GO
