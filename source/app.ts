import neo4j from "neo4j"

async function main() {
    // Create a Driver Instance
    const driver = neo4j.driver(
      'neo4j://localhost:7687',
      neo4j.auth.basic('neo4j', 'letmein!')
    )
  
    // Open a new Session
    const session = driver.session()
  
    try {
      // Execute a Cypher statement in a Read Transaction
      const res = await session.executeRead(tx => tx.run(`
        MATCH (p:Person)-[r:ACTED_IN]->(m:Movie {title: $title})
        RETURN p, r, m
      `, { title: 'Pulp Fiction' }))
  
      const people = res.records.map(row => row.get('p'))
  
      console.log(people)
    }
    finally {
      // Close the Session
      await session.close()
    }
  }