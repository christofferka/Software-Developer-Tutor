# Agent retrieval tools

## vector_search
- n8n workflow: `02 - Vector Retrieval`
- Input schema: `question` (string, required)
- Use when: the user asks for an explanation, related course material, how a technology works, or implementation concepts.
- Process: convert query to 1024-dimensional vector with Voyage AI (`voyage-4-lite`, `input_type: query`), run vector search against Neo4j index `chunk_embeddings`, retrieve matching chunk/document metadata.
- Expected output: `tool: vector_search`, `count`, `results[]` containing `chunkId`, `content`, `documentId`, `title`, `source`, `similarity`, and `topics`.
- Source: `project-created-seed-data` (self-authored example text). A similarity score indicates ranking, not factual proof.

## graph_search
- n8n workflow: `03 - Graph Retrieval`
- Input schema: `conceptId` (string, required)
- Use when: the user asks what to learn before or after a concept, or wants connections among indexed concepts.
- Process: find a `Concept` by ID/name, traverse inbound and outbound `LEARN_BEFORE` relations in Neo4j.
- Expected output: `tool: graph_search`, `found`, `results[]` containing `conceptId`, `concept`, `prerequisites`, `nextTopics`, `source`.
- Source: `project-curated-learning-path` (project-authored graph).

## Safeguards
- Tools are read-only and use parameterized Cypher queries.
- The graph reflects a curated example learning path, not an authoritative universal curriculum.
- Neither tool should claim an answer when the requested fact is absent from the data.
- Never send credentials or full embedding vectors to the user.
