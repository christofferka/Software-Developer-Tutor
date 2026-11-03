# Software Development Tutor: Neo4j Vector + Graph RAG

## Project overview
This project demonstrates Retrieval-Augmented Generation (RAG) using both semantic similarity and explicit graph relationships. The case is a software development tutor for students who want to learn Java, Spring Boot, SQL, HTTP, REST, JDBC, OOP, and MVC.

**Vector retrieval** identifies semantically relevant explanations from short educational texts. **Graph retrieval** finds explicit prerequisite and follow-up concept relationships. The **Claude** agent can use either tool or both, depending on the question, and should cite the retrieved sources.

## Architecture

```text
Self-authored text + curated concept relationships
           |                       |
           v                       v
01 Knowledge Ingestion        04 Graph Ingestion
  n8n -> Neo4j docs/chunks     n8n -> Neo4j concepts/edges
  n8n -> Voyage embeddings     (LEARN_BEFORE)
           |                       |
           +-----------+-----------+
                       v
             Neo4j AuraDB (same DB)
             Vector index + graph
                       ^
           +-----------+-----------+
           |                       |
   02 Vector Retrieval       03 Graph Retrieval
   Voyage query embedding    Cypher graph traversal
           |                       |
           +----------+------------+
                      v
              n8n Agents Builder
              Claude Sonnet agent
                      ^
                 User questions
```

## Stack
- **Orchestration:** n8n Cloud, workflow nodes and Agents Builder
- **Database:** Neo4j AuraDB, shared for graph nodes and embeddings
- **Embeddings:** Voyage AI `voyage-4-lite`, 1024-dimensional vectors
- **Agent:** Anthropic Claude (`claude-sonnet-4-6` observed during development; check final configuration)
- **HTTP integration:** n8n HTTP Request to Neo4j Query API and Voyage Embeddings API

## Repository contents
- `workflows/`: export of the 4 actual n8n workflows (**add your exported JSON files here**)
- `screenshots/`: readable overview of all workflows, agent tool connections, and real test/tool-call screenshots (**add your actual screenshots here**)
- `agent/agent-config.md`: model and configuration notes
- `agent/system-prompt.md`: proposed agent prompt; check it matches the actual one in n8n
- `agent/tool-descriptions.md`: workflow tool inputs, outputs, when to use each
- `data/documents.json`: eight self-authored text samples and metadata
- `data/graph-data.json`: eight concepts and eight curated prerequisite relationships
- `data/setup.cypher`: database constraints, vector index and checks
- `tests/evaluation-template.md`: template for documenting three *actual* agent runs, tool calls, retrieved information, answers, assessments, and observed failure/limitation

## Database model

| Node | Properties | Role |
|---|---|---|
| `Concept` | `id`, `name` | Technical topic |
| `Document` | `id`, `title`, `source` | Original educational item |
| `Chunk` | `id`, `text`, `position`, `source`, `embedding`, `embeddingModel` | Text section and semantic vector |

Relationships:
- `(Document)-[:HAS_CHUNK]->(Chunk)` links text to its source.
- `(Chunk)-[:ABOUT]->(Concept)` connects text to course topics.
- `(Concept)-[:LEARN_BEFORE]->(Concept)` represents a curated learning prerequisite.

Eight documents currently contain one chunk each. `project-created-seed-data` identifies our own sample content; `project-curated-learning-path` identifies our own prerequisite graph.

## Reproduce the project
1. Create an empty Neo4j AuraDB instance. Record the **actual database name, URI and username** provided by Aura. Do not assume the name is `neo4j`.
2. Run `data/setup.cypher` (or execute the statements individually) to create constraints and `chunk_embeddings`, a cosine index for 1024-dimensional embeddings.
3. Create n8n credentials for Neo4j HTTP Basic Auth and Voyage API Bearer Header Auth. Create an Anthropic API credential for the agent. **Never commit secrets.**
4. Import the exported JSON workflow files from `workflows/`. Update API endpoint URLs, credential references, node names and input schemas to match your environment.
5. Run `04 - Graph Ingestion` first to create the eight `Concept` nodes and their `LEARN_BEFORE` relationships. This matters because document ingestion references the concepts.
6. Run `01 - Knowledge Ingestion` to insert eight documents and their chunks, connect chunks to concepts, generate all embeddings with Voyage and write them to Neo4j. Texts are batched into a single Voyage API request to stay within API request limits.
7. Verify graph counts and embeddings using the checks below. Verify the vector index is `ONLINE` with 1024 dimensions.
8. Make `02 - Vector Retrieval` and `03 - Graph Retrieval` available as callable sub-workflows, with required input fields `question` and `conceptId` respectively.
9. Create or configure the Software Development Tutor in n8n Agents Builder. Connect Anthropic Claude and both retrieval workflows as tools, and copy the final prompt and descriptions from `agent/`. Confirm the model and publish state in the actual editor.
10. Run three live agent tests and save actual inputs, outputs, tool traces, cited sources and your assessments under `tests/` and `screenshots/`.

### Verification queries

```cypher
MATCH (c:Concept) RETURN count(c) AS concepts;
```
Expected for the seed dataset: `8`.

```cypher
MATCH ()-[r:LEARN_BEFORE]->() RETURN count(r) AS relationships;
```
Expected for the seed dataset: `8`.

```cypher
MATCH (d:Document) RETURN count(d) AS documents;
```
Expected: `8`.

```cypher
MATCH (c:Chunk)
RETURN count(c) AS totalChunks,
       count(c.embedding) AS embeddedChunks,
       collect(DISTINCT size(c.embedding)) AS dimensions;
```
Expected after ingestion: `8`, `8`, `[1024]`.

```cypher
SHOW VECTOR INDEXES;
```
Check index `chunk_embeddings` is `ONLINE` and has 1024 dimensions.

## Retrieval tools

| Tool | Input | Function | Return |
|---|---|---|---|
| `vector_search` | `question: string` | Embeds the query using Voyage and returns matching Neo4j chunks | Content, document title, source, score, topics |
| `graph_search` | `conceptId: string` | Traverses direct `LEARN_BEFORE` links | Concept, prerequisites, next topics, graph source |

## Evaluation and limitations
See `tests/evaluation-template.md` and the **actual** run screenshots for three demonstrations: vector-only style question, prerequisite graph question, and a question requiring both tools. Each submitted test must document retrieved information, tool calls, actual agent response, and a short assessment.

Main limitations: very small self-authored dataset; only one short chunk per document; manually curated direct learning relations; no independent authoritative source verification; retrieval quality cannot be inferred from workflow success alone. An observed failure or limitation must be recorded from actual testing.

## Security
Secrets are held in n8n credentials. Do not include raw Anthropic, Voyage, or Neo4j credentials in screenshots or JSON exports. Neo4j AuraDB instance IDs and account details can also be removed from publicly shared artifacts if unnecessary.
