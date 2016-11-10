DECLARE @DateRef DATETIME =Getdate()-20 -- par defaut, purge des messages de plus d'un mois

DECLARE @IDToDelete TABLE (
	ID INT
	,Provenance VARCHAR(50)
)

WHILE EXISTS (SELECT * FROM  [dbo].[TMessageSend] M	WHERE M.SendDate IS NOT  NULL AND m.CreationDate < @DateRef)
BEGIN
	delete from @IDToDelete

	INSERT INTO @IDToDelete
		SELECT TOP 1000 [pk_MessageSend],NULL
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
		checkpoint
END
