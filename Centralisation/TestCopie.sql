
DECLARE @ID INT

select @ID=ID FROM SourceTarget where SourceDatabase='Referentiel_EcoReleve.dbo.'

exec CopierUneSource @ID