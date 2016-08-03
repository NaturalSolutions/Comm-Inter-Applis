/****** Object:  Table [dbo].[TPropagation]    Script Date: 31/05/2016 10:57:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TPropagation](
	[Pk_ID] [int] IDENTITY(1,1) NOT NULL,
	[FB_ID] [int] NULL,
	[Source_ID] [int] NOT NULL,
	[Instance] [int] NOT NULL,
	[TypeObject] [varchar](50)  NULL,
	[Priority] [int] NOT NULL,
	[Propagation] [int] NOT NULL,
	[Date_Modif] [date] NOT NULL,
	[Comment] [varchar](max)  NULL,
 CONSTRAINT [PK_TPropagation] PRIMARY KEY CLUSTERED 
(
	[Pk_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


