
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_PurgeMessages]') AND type in (N'P', N'PC'))
DROP PROCEDURE sp_PurgeMessages
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[sp_PurgeMessages]
	@DateMin DATETIME = NULL,
	@Comportement TINYINT = 3 -- Poids binaire 2-> messages entrants, 1-> messages sortants
	
AS
BEGIN

DECLARE @DateRef DATETIME = @DateMin
IF @DateRef IS NULL SET @DateRef=Getdate()-30 -- par defaut, purge des messages de plus d'un mois

DECLARE @IDToDelete TABLE (
	ID INT
	,Provenance VARCHAR(50)
)

IF (@Comportement & 1) >0 -- Suppression message entrant
BEGIN
	INSERT INTO @IDToDelete
	SELECT [pk_MessageReceived],[Provenance]
	FROM [dbo].[TMessageReceived] M
	WHERE M.ImportDate IS NOT  NULL AND m.CreationDate < @DateRef

	DELETE D
	FROM [TMessageReceivedDetail]  D
	JOIN @IDToDelete I ON D.fk_MessageReceived = I.ID and D.Provenance = I.Provenance

	DELETE D
	FROM [TMessageReceived]  D
	JOIN @IDToDelete I ON D.pk_MessageReceived = I.ID and D.Provenance = I.Provenance

	
END

delete from @IDToDelete

IF (@Comportement & 2) >0 -- Suppression message entrant
BEGIN
	INSERT INTO @IDToDelete
	SELECT [pk_MessageSend],NULL
	FROM [dbo].[TMessageSend] M
	WHERE M.SendDate IS NOT  NULL AND m.CreationDate < @DateRef

	DELETE D
	FROM [TMessageSendDetail]  D
	JOIN @IDToDelete I ON D.fk_MessageSend = I.ID 


	DELETE D
	FROM [TMessageTransfertLog]  D
	JOIN @IDToDelete I ON D.fk_MessageSend = I.ID 

	DELETE D
	FROM [TMessageSend]  D
	JOIN @IDToDelete I ON D.pk_MessageSend = I.ID 

	
END


END