DECLARE @DateRef DATETIME =Getdate()-30 -- par defaut, purge des messages de plus d'un mois

DECLARE @IDToDelete TABLE (
	ID INT
	,Provenance VARCHAR(50)
)


WHILE EXISTS (SELECT * FROM  [TMessageReceived] M WHERE M.ImportDate IS NOT  NULL AND m.CreationDate < @DateRef)
BEGIN
		delete from @IDToDelete

		INSERT INTO @IDToDelete
		SELECT TOP 50000  [pk_MessageReceived],[Provenance]
		FROM [dbo].[TMessageReceived] M
		WHERE M.ImportDate IS NOT  NULL AND m.CreationDate < @DateRef

		DELETE D
		FROM [TMessageReceivedDetail]  D
		JOIN @IDToDelete I ON D.fk_MessageReceived = I.ID and D.Provenance = I.Provenance

		DELETE D
		FROM [TMessageReceived]  D
		JOIN @IDToDelete I ON D.pk_MessageReceived = I.ID and D.Provenance = I.Provenance
		checkpoint
END
