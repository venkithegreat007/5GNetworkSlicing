MATCH (n:Failed)
SET n.status = 'ACTIVE'
REMOVE n:Failed
