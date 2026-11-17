import org.neo4j.driver.AuthTokens;
import org.neo4j.driver.Driver;
import org.neo4j.driver.GraphDatabase;
import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;

public class FailureSimulation {

    private static final String URI = "bolt://localhost:7687";
    private static final String USER = "";
    private static final String PASSWORD = "";

    public static void main(String[] args) {


        try (Driver driver = GraphDatabase.driver(URI, AuthTokens.basic(USER, PASSWORD));
             Session session = driver.session()) {

            System.out.println("\n[SYSTEM ALARM] Simulating physical cut on Fiber-101...\n");


            String query =
                    "MATCH (p:PhysicalNode {id: 'Fiber-101'}) " +
                            "SET p.status = 'FAILED' " +
                            "WITH p " +
                            "MATCH path = (p)-[:CONNECTS_TO]-(r:EdgeRouter)-[:HOSTS]->(v:VirtualNetworkFunction)<-[:UTILIZES]-(ns:NetworkSlice)<-[:SUBSCRIBES_TO]-(c:Client) " +
                            "RETURN DISTINCT c.name AS AffectedClient, c.industry AS Industry, ns.sliceType AS BrokenSlice, c.slaPenalty AS CostPerMin";


            Result result = session.run(query);


            int totalSlaExposure = 0;
            int clientsAffected = 0;


            System.out.println(String.format("%-25s %-15s %-40s %-10s", "CLIENT", "INDUSTRY", "BROKEN SLICE", "PENALTY/MIN"));
            System.out.println("------------------------------------------------------------------------------------------------");


            while (result.hasNext()) {
                Record record = result.next();
                String client = record.get("AffectedClient").asString();
                String industry = record.get("Industry").asString();
                String slice = record.get("BrokenSlice").asString();
                int penalty = record.get("CostPerMin").asInt();


                totalSlaExposure += penalty;
                clientsAffected++;

                System.out.println(String.format("%-25s %-15s %-40s $%d", client, industry, slice, penalty));
            }

            System.out.println("------------------------------------------------------------------------------------------------");
            System.out.println(">>> FAULT REPORT:");
            System.out.println(">>> Total Clients Knocked Offline: " + clientsAffected);
            System.out.println(">>> Total SLA Financial Risk:      $" + totalSlaExposure + " / minute\n");

        } catch (Exception e) {
            System.err.println("Database Connection Error: Make sure Neo4j Desktop is running!");
            e.printStackTrace();
        }
    }
}
