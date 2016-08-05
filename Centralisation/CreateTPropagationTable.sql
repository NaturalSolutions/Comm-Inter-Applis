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
 CONSTRAINT [PK_TPropagation] PRIMARY KEY CLUSTERED (	[Pk_ID] )
) 


-- insertion de la règle de propagation par défaut.

INSERT INTO [dbo].[TPropagation]
           ([FB_ID]
           ,[Source_ID]
           ,[Instance]
           ,[TypeObject]
           ,[Priority]
           ,[Propagation]
           ,[Date_Modif]
           ,[Comment])
     VALUES
           (-1
           ,-1
           ,-1
           ,NULL
           ,50
           ,1
           ,getdate()
           ,NULL)
GO




