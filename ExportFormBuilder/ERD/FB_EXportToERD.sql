USE [Referentiel_EcoReleve]
GO
/****** Object:  StoredProcedure [dbo].[pr_ExportFormBuilder]    Script Date: 25/11/2016 11:04:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[pr_ExportFormBuilder] 
AS
BEGIN


DELETE FormBuilderInputProperty 
DELETE FormBuilderInputInfos 
DELETE FormBuilderFormsInfos 

/**************** INSERT FormsInfos ***********************/

 SET IDENTITY_INSERT  [FormBuilderFormsInfos] ON;      
 INSERT INTO [FormBuilderFormsInfos]
           (ID
      ,[name]
      ,[tag]
      ,[labelFr]
      ,[labelEn]
      ,[creationDate]
      ,[modificationDate]
      ,[curStatus]
      ,[descriptionFr]
      ,[descriptionEn]
      ,[obsolete]
      ,[isTemplate]
      ,[context]
	  ,ObjectType)
 
 SELECT   [pk_Form]
      ,[name]
      ,[tag]
      ,[labelFr]
      ,[labelEn]
      ,[creationDate]
      ,[modificationDate]
      ,[curStatus]
      ,[descriptionFr]
      ,[descriptionEn]
      ,[obsolete]
      ,[isTemplate]
      ,[context]
      ,'Protocole'
 FROM [formbuilder].dbo.Form fo 
 WHERE context = 'ecoreleve'
 ;
  SET IDENTITY_INSERT  [FormBuilderFormsInfos] OFF;    
 -- TODO ajouter le nom de l'application


/**************** INSERT InputInfos ***********************/

SET IDENTITY_INSERT  [FormBuilderInputInfos] ON;  
with toto (ID) as (
SELECT Max(pk_Fieldset)
  FROM Formbuilder.[dbo].[Fieldset]
  group by [refid])

  
INSERT INTO [FormBuilderInputInfos]
      (ID
      ,[fk_form]
      ,[name]
      ,[labelFr]
      ,[labelEn]
      ,[required]
      ,[readonly]
      ,[fieldSize]
	  ,atBeginingOfLine
      ,[endOfLine]
      ,[startDate]
      ,[curStatus]
      ,[type]
      ,[editorClass]
      ,[fieldClassEdit]
      ,[fieldClassDisplay]
    ,[linkedFieldTable]
      ,[linkedFieldIdentifyingColumn]
      ,[linkedField]
    ,[order]
	,Legend
    )
SELECT pk_Input
           ,I.[fk_form]
           ,I.[name]
           ,I.[labelFr]
           ,I.[labelEn]
           ,CASE WHEN I.editMode < 7 THEN 1 ELSE 0 END as required_
           ,0
           ,I.[fieldSize]
		   ,I.atBeginingOfLine
           ,I.[endOfLine]
           ,I.[startDate]
           ,I.[curStatus]
           ,I.[type] 
           ,I.[editorClass]
           ,I.[fieldClassEdit]
           ,I.[fieldClassDisplay]
           ,I.[linkedFieldTable]
           ,I.[linkedFieldIdentifyingColumn]
           ,I.[linkedField]
           ,I.[order]
		   ,I.linkedFieldset
       
           FROM Formbuilder.dbo.Input I
       --LEFT JOIN Formbuilder.dbo.InputProperty ip ON I.pk_Input = ip.fk_Input AND I.type = 'Date' AND ip.name = 'format'
       --LEFT JOIN FormBuilder.dbo.Fieldset F ON I.linkedFieldset = F.refid --and F.pk_Fieldset in (select * from toto)
       WHERE i.fk_form in (select ID from [FormBuilderFormsInfos]) AND I.[curStatus] = 1 



SET IDENTITY_INSERT  [FormBuilderInputInfos] OFF;  



/**************** INSERT InputProperty ***********************/

SET IDENTITY_INSERT  [FormBuilderInputProperty] ON;  

INSERT INTO [FormBuilderInputProperty]
           (ID
           ,[fk_Input]
           ,[name]
           ,[value]
           ,[creationDate]
           ,[valueType])
 SELECT [pk_InputProperty]
      ,[fk_Input]
      ,IP.[name]
      ,IP.[value]
      ,IP.[creationDate]
      ,IP.[valueType]
  FROM Formbuilder.[dbo].[InputProperty] IP WHERE fk_Input in (select ID FROM [FormBuilderInputInfos])

SET IDENTITY_INSERT  [FormBuilderInputProperty] OFF;  
 
 ---EXEC dbo.[pr_ImportFormBuilder] 
END






