// Run once on a new Neo4j AuraDB instance, or safely rerun.
// This schema is also populated by the n8n workflows.
CREATE CONSTRAINT concept_id_unique IF NOT EXISTS
FOR (c:Concept) REQUIRE c.id IS UNIQUE;

CREATE CONSTRAINT document_id_unique IF NOT EXISTS
FOR (d:Document) REQUIRE d.id IS UNIQUE;

CREATE CONSTRAINT chunk_id_unique IF NOT EXISTS
FOR (c:Chunk) REQUIRE c.id IS UNIQUE;

CREATE VECTOR INDEX chunk_embeddings IF NOT EXISTS
FOR (c:Chunk) ON (c.embedding)
OPTIONS {
  indexConfig: {
    `vector.dimensions`: 1024,
    `vector.similarity_function`: 'cosine'
  }
};

// Verification queries (run separately if your Neo4j Query editor requires it):
// SHOW VECTOR INDEXES;
// MATCH (c:Concept) RETURN count(c) AS conceptCount;
// MATCH ()-[r:LEARN_BEFORE]->() RETURN count(r) AS prerequisiteRelations;
// MATCH (d:Document) RETURN count(d) AS documentCount;
// MATCH (c:Chunk)
// RETURN count(c) AS totalChunks,
//        count(c.embedding) AS embeddedChunks,
//        collect(DISTINCT size(c.embedding)) AS embeddingDimensions;
