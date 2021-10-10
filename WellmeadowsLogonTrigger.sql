--Logon Trgger
--The out patient clinic has working hours. In this case, it's 8am to 8pm.
 
-- block receptionist Joann from connecting to Sql Server after clinic hours
USE Wellmeadows
GO
Go
ALTER TRIGGER LimitConnectionAfterHours
ON ALL SERVER 
FOR LOGON
AS
BEGIN
 IF ORIGINAL_LOGIN() = 'Joann' AND
  (DATEPART(HOUR, GETDATE()) < 8  OR
   DATEPART (HOUR, GETDATE()) >= 20)
 BEGIN
  PRINT 'You are not authorized to login after clinic hours'
  ROLLBACK
 END
END


