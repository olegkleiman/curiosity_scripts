/****** Object:  StoredProcedure [dbo].[calculateDistance]    Script Date: 07/09/2023 17:17:18 ******/
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
   @inputText nvarchar(max)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	declare @retval int, @response nvarchar(max)
	declare @headers nvarchar(max)
	set @headers = json_object(
		'api-key':'1caa8932bf794b3b9046446b65130822',
		'Content-Type': 'application/json'
	)
	if exists(select * from sys.[database_scoped_credentials] 
				where name = 'https://curiosity.openai.azure.com')
	begin
		drop database scoped credential [https://curiosity.openai.azure.com];
	end
	create database scoped credential [https://curiosity.openai.azure.com]
	with identity = 'HTTPEndpointHeaders', secret = '{"api-key": "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"}';
	
	declare @payload nvarchar(max) = json_object('input': @inputText);

	exec @retval = sp_invoke_external_rest_endpoint
		@url = 'https://curiosity.openai.azure.com/openai/deployments/curiosity_deployment/embeddings?api-version=2022-12-01',
		@method = 'POST',
		@headers = @headers,
		@payload = @payload,
		@response = @response output;

	drop table if exists #response;
	select @response as [response] into #response;

	drop table if exists #t;
	select 
		cast([key] as int) as [vector_value_id],
		cast([value] as float) as [vector_value]
	into    
		#t
	from 
		openjson(@response, '$.result.data[0].embedding')

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

	select top 5
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
