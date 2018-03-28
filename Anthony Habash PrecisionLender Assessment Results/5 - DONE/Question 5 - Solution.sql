--Tony Habash
-- Question 5 Solution

WITH StatusLength (TicketID, Status, Length) AS
(
SELECT sc1.TicketID, sc2.NewStatus, DATEDIFF(MINUTE,sc2.Timestamp,sc1.Timestamp) AS 'Diff'   
FROM StatusChange sc1 
JOIN StatusChange sc2 
ON sc1.TicketID = sc2.TicketID 
AND sc1.OldStatus = sc2.NewStatus 
UNION
SELECT sc1.TicketID, sc1.NewStatus, DATEDIFF(MINUTE,latestStamp.MaxStamp,GETDATE()) AS 'Diff'
FROM StatusChange sc1 
JOIN (SELECT 	TicketID,
		MAX(Timestamp) AS MaxStamp
		FROM StatusChange GROUP BY TicketID) latestStamp  
ON sc1.TicketID = latestStamp.TicketID 
AND sc1.Timestamp = latestStamp.MaxStamp
)

SELECT	t.Id, 
		t.Summary, 
		NewResults.Length AS 'New', 
		InProgressResults.Length AS 'In Progress',
		ClosedResults.Length As 'Closed',
		ReopenedResults.Length AS 'Reopened'
FROM Ticket t 
LEFT JOIN (SELECT * FROM StatusLength WHERE Status = 'New') NewResults ON t.Id = NewResults.TicketID
LEFT JOIN (SELECT * FROM StatusLength WHERE Status = 'In Progress') InProgressResults ON t.Id = InProgressResults.TicketID
LEFT JOIN (SELECT * FROM StatusLength WHERE Status = 'Closed') ClosedResults ON t.Id = ClosedResults.TicketID
LEFT JOIN (SELECT * FROM StatusLength WHERE Status = 'Reopened') ReopenedResults ON t.Id = ReopenedResults.TicketID