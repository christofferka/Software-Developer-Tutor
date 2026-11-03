# Software Development Tutor

## About the project

This project is an AI tutor that helps students learn software development. You can ask questions about Java, SQL, JDBC, REST APIs, MVC and Spring Boot.

The tutor can explain programming concepts, find relevant learning material and show how different topics are connected.

The project uses both **Vector RAG and Graph RAG**.

RAG stands for Retrieval-Augmented Generation. This means the AI searches for information before answering a question.

The two search methods work differently:

- **Vector Search:** Finds learning material based on meaning. For example, if someone asks how Java connects to a database, it can find the JDBC document even if the question does not mention JDBC.
- **Graph Search:** Finds connections between programming topics. For example, it can show which concepts a student should learn before Spring Boot.

The AI tutor uses Claude. It decides which search tool to use and combines the information to answer the student's question.

## Technologies Used

| Technology | Purpose |
|---|---|
| n8n Cloud | Building and running workflows |
| n8n Agents Builder | Creating the AI tutor |
| Claude Sonnet 4.6 | AI model used by the tutor |
| Neo4j AuraDB | Graph database and vector database |
| Voyage AI | Creating text embeddings |
| HTTP Requests | Connecting n8n with the APIs |

Both Vector RAG and Graph RAG use the same Neo4j database.

## How the System Works

The student asks the AI tutor a question.

Claude then decides which tool to use.

**Vector Search:**
1. The question is sent to Voyage AI.
2. Voyage AI converts it into an embedding.
3. Neo4j searches for similar embeddings.
4. The most relevant documents are returned to Claude.

**Graph Search:**
1. Claude identifies the programming topic.
2. Neo4j searches for related concepts.
3. The relationships are returned to Claude.

Claude uses the retrieved information to answer the student's question and provide sources.

For questions that require both explanations and relationships, Claude can use both tools.

## Project Files

The repository contains four n8n workflows, their screenshots, the agent configuration, data files and three tests.

### Workflows

| File | Description |
|---|---|
| `01 - Knowledge Ingestion.json` | Imports learning material and creates embeddings |
| `02 - Vector Retrieval.json` | Searches for relevant documents |
| `03 - Graph Retrieval.json` | Searches for relationships between topics |
| `04 - Graph Ingestion.json` | Creates concepts and relationships in Neo4j |

Each workflow also has a screenshot:

- `01 - Workflow Screenshot.png`
- `02 - Workflow Screenshot.png`
- `03 - Workflow Screenshot.png`
- `04 - Workflow Screenshot.png`

### Other Files

**agent/**

Contains information about the AI agent, including its model, instructions and tool descriptions.

**data/**

Contains the sample data and information needed to recreate the Neo4j database.

**Test 1.pdf**

Shows the Vector RAG test.

**Test 2.pdf**

Shows the Graph RAG test.

**Test 3.pdf**

Shows the combined Vector and Graph RAG test.

**Evaluation.md**

Contains my evaluation of the three tests, including what worked, what failed and what I would improve.

## The Four Workflows

### 01. Knowledge Ingestion

This workflow adds learning material to Neo4j.

It starts with eight short documents about different programming topics.

The workflow:

1. Prepares the documents.
2. Saves them in Neo4j.
3. Sends the text to Voyage AI.
4. Receives embeddings.
5. Saves the embeddings in Neo4j.

Each document has a title, ID, text and source information.

I used one chunk per document because the texts are already quite short.

The embeddings are created with the `voyage-4-lite` model and have 1,024 dimensions.

### 02. Vector Retrieval

This workflow searches for relevant learning material.

It receives a question, converts it into an embedding using Voyage AI and searches Neo4j for similar documents.

It returns the three most relevant text chunks, including their titles, sources and similarity scores.

Claude uses this tool when a student asks for explanations or learning material.

### 03. Graph Retrieval

This workflow searches the relationships between programming topics.

For example, when searching for Spring Boot, it can return the concepts that should be learned first.

It uses Cypher queries to search Neo4j.

Claude uses this tool when a student asks about prerequisites, learning paths or connections between topics.

### 04. Graph Ingestion

This workflow creates the programming concepts and their relationships in Neo4j.

The graph currently contains eight concepts and eight `LEARN_BEFORE` relationships.

The workflow uses `MERGE` to avoid creating duplicate nodes and relationships when it runs again.

## Data and Database Structure

The project uses eight short learning documents:

1. Introduction to Java
2. Object-Oriented Programming
3. Understanding HTTP
4. REST API Fundamentals
5. Introduction to SQL
6. Java Database Connectivity
7. MVC Architecture
8. Spring Boot Fundamentals

These texts were written for this project. They are not taken from external textbooks.

### Node Types

| Node | Description |
|---|---|
| Document | Stores the document title and source |
| Chunk | Stores the text and its embedding |
| Concept | Represents a programming topic |

### Relationship Types

| Relationship | Description |
|---|---|
| HAS_CHUNK | Connects a document to its text |
| ABOUT | Connects a text to a programming topic |
| LEARN_BEFORE | Shows which topic should be learned before another |

The graph contains eight programming concepts and eight learning relationships.

These relationships are recommendations made for this project, not an official learning curriculum.

## AI Agent

The agent is called **Software Development Tutor**.

It was created using n8n Agents Builder and uses `claude-sonnet-4-6`.

The agent has two tools:

**Vector Retrieval**

Input: `question`

Searches the learning documents and returns relevant text, document titles and sources.

**Graph Retrieval**

Input: `conceptId`

Searches for a programming concept and returns its prerequisites and related topics.

The agent is instructed to use the tools when answering questions about the available course material.

It should also include sources and explain when it does not have enough information to answer a question.

The complete agent instructions and tool descriptions are included in the `agent/` folder.

No additional agent skills were used.

## How to Set Up the Project

### 1. Create a Neo4j Database

Create a free Neo4j AuraDB instance.

Save the connection URI, database name, username and password.

### 2. Set Up the Database

Create the necessary database indexes, including the vector index for embeddings with 1,024 dimensions.

Use the setup information in the `data/` folder.

### 3. Import the Workflows

Import the four JSON files into n8n.

### 4. Add API Credentials

Add the following credentials in n8n:

- Neo4j database credentials
- Voyage AI API key
- Anthropic API key for Claude

The API keys and passwords are not included in the repository.

### 5. Run the Ingestion Workflows

Run the workflows in this order:

1. `04 - Graph Ingestion`
2. `01 - Knowledge Ingestion`

The first workflow creates the concepts and relationships.

The second workflow imports the documents and generates embeddings.

### 6. Configure the AI Agent

Create an agent in n8n Agents Builder.

Select Claude as the model and connect the two retrieval workflows as tools.

Use the instructions and tool descriptions from the `agent/` folder.

### 7. Test the Agent

Use the questions from the three test PDFs to check that the agent can retrieve information and answer correctly.

## Testing

I tested the agent with three different questions.

### Test 1: Vector RAG

**Question:**

How can I connect a Java application to a relational database? Explain the process using the available learning material.

**Result:**

The agent found the JDBC document even though the question did not mention JDBC.

It also found information about SQL and Spring Boot. The answer explained how Java connects to databases and included references to the learning material.

The agent also used the graph tool to show the relationship between SQL, JDBC and Spring Boot.

### Test 2: Graph RAG

**Question:**

What concepts should I learn before Spring Boot according to the knowledge graph?

**Result:**

The agent first searched for `spring-boot`, but that ID did not exist in the graph.

It then searched for `spring` and found the correct information.

The answer included all five prerequisites stored in Neo4j: Java, OOP, REST API, JDBC and MVC Architecture.

### Test 3: Combined RAG

**Question:**

I already know Java and SQL. I want to learn Spring Boot. What other concepts should I study first, and can you explain how they relate to Spring Boot using the course material?

**Result:**

The agent used both Vector Retrieval and Graph Retrieval.

It found the prerequisites for Spring Boot and retrieved learning material to explain them.

However, some additional vector searches failed because the Voyage AI API rate limit was reached.

The agent still produced a useful answer using the information it had already retrieved.

The full test results and screenshots are included in `Test 1.pdf`, `Test 2.pdf` and `Test 3.pdf`.

My assessment of the results is included in `Evaluation.md`.

## Limitations and Improvements

The project works as a small prototype, but there are still some limitations.

**Limited learning material**

The database only contains eight short documents. This is enough to demonstrate RAG, but not enough for a complete programming tutor.

**Topic names**

The graph search depends on matching concept names or IDs. During testing, `spring-boot` did not work, while `spring` did.

This could be improved by supporting alternative names.

**API rate limits**

Voyage AI has request limits. During the combined test, several requests failed because too many searches were made within a short period.

I would improve this by adding better retry handling and controlling how often requests are sent.

**Manual data updates**

The ingestion workflows are started manually and use predefined data. A future version could automatically import new documents.

## Conclusion

The project shows how Vector RAG and Graph RAG can work together in an AI application.

Vector Search helps Claude find relevant explanations, while Graph Search helps it understand how programming topics are connected.

The tests show that the agent can use both tools to answer questions and recommend learning material.

There are still some limitations, especially the small amount of data and the API rate limits, but the project works as a prototype and demonstrates how the two retrieval methods can support each other.
