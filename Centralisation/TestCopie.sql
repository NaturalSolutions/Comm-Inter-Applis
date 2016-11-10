
DECLARE @ID INT

select @ID=ID FROM SourceTarget where SourceDatabase='NARC_TRACK_MACQ_New.dbo.'

exec CopierUneSource @ID
