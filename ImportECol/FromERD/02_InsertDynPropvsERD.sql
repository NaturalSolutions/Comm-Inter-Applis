INSERT INTO [TMessageDynPropvsERD]
           ([ERDName]
           ,[EColName]
           ,TypeProp)
     VALUES
           ('LAT'
           ,'LAT'
           ,'float')
GO
INSERT INTO [TMessageDynPropvsERD]
           ([ERDName]
           ,[EColName]
           ,TypeProp)
     VALUES
           ('LON'
           ,'LON'
           ,'float')
GO
INSERT INTO [TMessageDynPropvsERD]
           ([ERDName]
           ,[EColName]
           ,TypeProp)
     VALUES
           ('ELE'
           ,'ELE'
           ,'float')


INSERT INTO [TMessageDynPropvsERD]
           ([ERDName]
           ,[EColName]
           ,TypeProp)
     VALUES
           ('precision'
           ,'precision'
           ,'string')

Go

INSERT INTO [TMessageDynPropvsERD]
           ([ERDName]
           ,[EColName]
           ,TypeProp)
     VALUES
           ('fieldActivity'
           ,'fieldActivity'
           ,'string')


INSERT INTO [TMessageDynPropvsERD]
           ([ERDName]
           ,[EColName]
           ,TypeProp)
     VALUES
           ('Place'
           ,'Place'
           ,'string')

INSERT INTO [TMessageDynPropvsERD]
           ([ERDName]
           ,[EColName]
           ,TypeProp)
     VALUES
           ('Region'
           ,'Region'
           ,'string')

INSERT INTO [TMessageDynPropvsERD]
           ([ERDName]
           ,[EColName]
           ,TypeProp)
     VALUES
           ('StationDate'
           ,'StationDate'
           ,'Date')



INSERT INTO SubjectDynProps (Name,TypeProp)
SELECT [EColName],TypeProp 
FROM TMessageDynPropvsERD T
WHERE NOT EXISTs (SELECT * FROM SubjectDynProps D where D.Name = t.[EColName])
