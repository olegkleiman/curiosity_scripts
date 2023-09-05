/****** Object:  StoredProcedure [dbo].[calculateDistance]    Script Date: 05/09/2023 13:43:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[calculateDistance]
(
    @VectorJson nvarchar(max)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	SELECT
		cast([key] as int) as vector_value_id,
		cast([value] as float) as vector_value
	into #t
	FROM openjson(@VectorJson);

	-- select * from #t

	select
		v2.doc_id,
		sum(v1.[vector_value] * v2.[vector_value]) as cosine_distance
	into #results
	from 
		#t v1
	inner join 
		dbo.site_docs_vector v2 on v1.vector_value_id = v2.vector_value_id
	group by 
		v2.doc_id
	order by
		cosine_distance desc

	select 
		a.id,
		a.title,
		a.url,
		r.cosine_distance
	from #results r
	inner join 
		[dbo].[site_docs] a on r.doc_id = a.id
	order by
		cosine_distance desc
	

	drop table #results
	drop table #t

END
GO


