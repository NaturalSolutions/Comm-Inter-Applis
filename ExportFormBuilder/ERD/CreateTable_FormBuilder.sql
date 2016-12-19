
/****** Object:  Table [dbo].[FormBuilderFormsInfos]    Script Date: 25/07/2016 10:34:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF OBJECT_ID (N'FormBuilderInputProperty', N'U') IS NOT NULL 
DROP TABLE [FormBuilderInputProperty]

IF OBJECT_ID (N'FormBuilderInputInfos', N'U') IS NOT NULL 
DROP TABLE [FormBuilderInputInfos]


IF OBJECT_ID (N'FormBuilderFormsInfos', N'U') IS NOT NULL 
DROP TABLE [FormBuilderFormsInfos]

IF OBJECT_ID (N'FormBuilderType_DynPropType', N'U') IS NOT NULL 
DROP TABLE [FormBuilderType_DynPropType]


CREATE TABLE [dbo].[FormBuilderFormsInfos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [varchar](100) NOT NULL,
	[tag] [varchar](300) NULL,
	[labelFr] [varchar](300) NOT NULL,
	[labelEn] [varchar](300) NOT NULL,
	[creationDate] [datetime] NOT NULL,
	[modificationDate] [datetime] NULL,
	[curStatus] [int] NOT NULL,
	[descriptionFr] [varchar](300) NOT NULL,
	[descriptionEn] [varchar](300) NOT NULL,
	[obsolete] [bit] NULL,
	[isTemplate] [bit] NOT NULL,
	[context] [varchar](50) NOT NULL,
	[ObjectType] [varchar](50) NOT NULL,
	[internalID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


CREATE TABLE [dbo].[FormBuilderInputInfos](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[fk_form] [bigint] NOT NULL,
	[name] [varchar](100) NOT NULL,
	[labelFr] [varchar](300) NOT NULL,
	[labelEn] [varchar](300) NOT NULL,
	[editMode] [int] NULL,
	[required] [bit] NOT NULL,
	[readonly] [bit] NOT NULL,
	[fieldSize] [varchar](100) NOT NULL,
	atBeginingOfLine [bit] NOT NULL,
	[endOfLine] [bit] NOT NULL,
	[startDate] [datetime] NOT NULL,
	[curStatus] [int] NOT NULL,
	[order] [smallint] NULL,
	[type] [varchar](100) NOT NULL,
	[editorClass] [varchar](100) NULL,
	[fieldClassEdit] [varchar](100) NULL,
	[fieldClassDisplay] [varchar](100) NULL,
	[linkedFieldTable] [varchar](100) NULL,
	[linkedFieldIdentifyingColumn] [varchar](100) NULL,
	[linkedField] [varchar](100) NULL,
	[linkedFieldset] [varchar](100) NULL,
	[Legend] [varchar](100) NULL,
	InternalID int null
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[FormBuilderInputProperty](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[fk_Input] [bigint] NOT NULL,
	[name] [varchar](255) NOT NULL,
	[value] [varchar](5000) NOT NULL,
	[creationDate] [datetime] NOT NULL,
	[valueType] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[FormBuilderType_DynPropType](
	[ID] [int]  IDENTITY(1,1) NOT NULL,
	[FBType] [nvarchar](100) NOT NULL,
	[FBInputPropertyName] [varchar](100) NULL,
	[FBInputPropertyValue] [varchar](255) NULL,
	[IsEXISTS] [bit] NULL,
	[DynPropType] [nvarchar](250) NOT NULL,
	[BBEditor] [nvarchar](250) NOT NULL
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
DELETE [FormBuilderType_DynPropType]
INSERT INTO [FormBuilderType_DynPropType] (
[FBType]
      ,[FBInputPropertyName]
      ,[FBInputPropertyValue]
      ,[IsEXISTS]
      ,[DynPropType]
      ,[BBEditor])
VALUES ('Checkboxes',NULL,NULL,1,'Integer','Checkbox'),
('CheckBox',NULL,NULL,1,'Integer','Checkbox'),
--('Radio',NULL,NULL,1,'Integer','Checkbox'),
('ChildForm',NULL,NULL,1,'String','ListOfNestedModel'),
('Number','decimal','1',1,'Float','Number'),
('Number','decimal','1',0,'Integer','Number'),
('BigLabel',NULL,NULL,1,'String','BigLabel'),
('Date','format','DD/MM/YYYY HH:mm:ss',1,'Date','DateTimePickerEditor'),
('Date','format','HH:mm:ss',1,'Time','DateTimePickerEditor'),
('Date','format','DD/MM/YYYY',1,'Date Only','DateTimePickerEditor'),
('Autocomplete',NULL,NULL,1,'String','AutocompleteEditor'),
('Autocomplete',NULL,NULL,1,'Integer','AutocompleteEditor'),
('Thesaurus',NULL,NULL,1,'String','AutocompTreeEditor')
--('Text',NULL,NULL,1,'String','TextArea')

GO

SET ANSI_PADDING OFF
GO


