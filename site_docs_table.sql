SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[site_docs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[doc] [nvarchar](max) NOT NULL,
	[title] [nvarchar](max) NOT NULL,
	[url] [nvarchar](max) NOT NULL,
	[address] [nvarchar](max) NULL,
	[location] [geography] NULL,
	[starts] [datetime] NULL,
	[ends] [datetime] NULL,
 CONSTRAINT [PK__site_doc__3214EC0791352496] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
