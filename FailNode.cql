MATCH path = (c)-[:SUBSCRIBES_TO]->(s)-[:UTILIZES]->(v)<-[:HOSTS]-(r)<-[:CONNECTS_TO]-(f {id: 'Fiber-101'})
UNWIND nodes(path) AS n
SET n.status = 'FAILED'
REMOVE n:Client, n:NetworkSlice, n:VirtualNetworkFunction, n:EdgeRouter, n:PhysicalNode
SET n:Failed
