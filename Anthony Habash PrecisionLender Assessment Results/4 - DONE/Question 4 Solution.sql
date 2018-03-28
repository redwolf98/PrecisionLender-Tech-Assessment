--Tony Habash
--Solution to question 4 of the PrecisionLender Developer Technical Screening

SELECT t.Id, t.Summary, st.Timestamp, st.NewStatus FROM Ticket t INNER JOIN
	(SELECT s.TicketID, s.Timestamp, s.NewStatus FROM StatusChange s INNER JOIN
	   (SELECT 	TicketID,
		MAX(Timestamp) AS MaxStamp
		FROM StatusChange GROUP BY TicketID) maxtime 
	 ON s.TicketID = maxtime.TicketID
	 AND s.Timestamp = maxtime.MaxStamp) st
ON t.Id = st.TicketID WHERE st.NewStatus <> 'Closed'