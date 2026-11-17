CREATE 
  // Physical Layer
  (fiber1:PhysicalNode {id: 'Fiber-101', name: 'Main East Trunk', type: 'Fiber', status: 'ACTIVE'}),
  (fiber2:PhysicalNode {id: 'Fiber-102', name: 'Backup West Trunk', type: 'Fiber', status: 'ACTIVE'}),
  (tower1:PhysicalNode {id: 'Tower-N1', name: 'North Cell Tower', type: 'Radio', status: 'ACTIVE'}),
  (tower2:PhysicalNode {id: 'Tower-S1', name: 'South Cell Tower', type: 'Radio', status: 'ACTIVE'}),
  (router1:EdgeRouter {id: 'Router-Core-1', name: 'Primary Core Router', status: 'ACTIVE'}),
  (router2:EdgeRouter {id: 'Router-Edge-1', name: 'Local Edge Router', status: 'ACTIVE'}),

  // Virtual Network Functions
  (upf1:VirtualNetworkFunction {id: 'UPF-01', name: 'User Plane Function Primary', status: 'ACTIVE'}),
  (amf1:VirtualNetworkFunction {id: 'AMF-01', name: 'Access Management Function', status: 'ACTIVE'}),
  (smf1:VirtualNetworkFunction {id: 'SMF-01', name: 'Session Management Function', status: 'ACTIVE'}),

  // 5G Slices
  (sliceHealthcare:NetworkSlice {id: 'Slice-URLLC', sliceType: 'Ultra-Reliable Low-Latency (URLLC)'}),
  (sliceAuto:NetworkSlice {id: 'Slice-V2X', sliceType: 'Vehicle-to-Everything (V2X)'}),
  (sliceIoT:NetworkSlice {id: 'Slice-mMTC', sliceType: 'Massive Machine Type Comms (mMTC)'}),

  // Clients
  (hospital:Client {id: 'C-01', name: 'City General Hospital', industry: 'Healthcare', slaPenalty: 5000}),
  (roboTaxi:Client {id: 'C-02', name: 'Waymo Auto Fleet', industry: 'Transportation', slaPenalty: 12000}),
  (smartGrid:Client {id: 'C-03', name: 'National Energy Grid', industry: 'Utilities', slaPenalty: 2500}),

  // Relationships (Building the Web)
  (fiber1)-[:CONNECTS_TO]->(router1),
  (fiber2)-[:CONNECTS_TO]->(router1),
  (tower1)-[:CONNECTS_TO]->(router2),
  (tower2)-[:CONNECTS_TO]->(router2),
  (router2)-[:CONNECTS_TO]->(router1),
  
  (router1)-[:HOSTS]->(upf1),
  (router1)-[:HOSTS]->(amf1),
  (router2)-[:HOSTS]->(smf1),
  
  (upf1)-[:DEPENDS_ON]->(amf1),
  (amf1)-[:DEPENDS_ON]->(smf1),
  
  (sliceHealthcare)-[:UTILIZES]->(upf1),
  (sliceHealthcare)-[:UTILIZES]->(amf1),
  
  (sliceAuto)-[:UTILIZES]->(upf1),
  (sliceAuto)-[:UTILIZES]->(smf1),
  
  (sliceIoT)-[:UTILIZES]->(smf1),
  
  (hospital)-[:SUBSCRIBES_TO]->(sliceHealthcare),
  (roboTaxi)-[:SUBSCRIBES_TO]->(sliceAuto),
  (smartGrid)-[:SUBSCRIBES_TO]->(sliceIoT);