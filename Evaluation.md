# Evaluation of the Software Development Tutor

I tested the AI tutor with three questions to see if it could find the right course material, use the knowledge graph, and give useful answers. The full answers and screenshots of the tool calls are in `Test 1.pdf`, `Test 2.pdf`, and `Test 3.pdf`.

## Test 1: Vector Search

**Question:** How can I connect a Java application to a relational database? Explain the process using the available learning material.

**Tools used:** The agent used `02 - Vector Retrieval` and then `03 - Graph Retrieval` for `jdbc`.

**Information found:** It found the documents *Java Database Connectivity* (`jdbc-01`), *Introduction to SQL* (`sql-01`), and *Spring Boot Fundamentals* (`spring-01`). The graph also showed the learning path from SQL to JDBC to Spring Boot.

**Agent's answer:** The agent explained that JDBC connects Java applications to relational databases. It described how SQL and JDBC work together, gave a Java code example, and suggested what to learn next. It also referred to the documents it found. The complete answer is in `Test 1.pdf`.

**My evaluation:** This test went well. The question did not mention JDBC, but the agent still found the right material. The answer was clear and useful. However, the code example included details that were not in the short course texts, and it was not a complete production-ready example.

## Test 2: Graph Search

**Question:** What concepts should I learn before Spring Boot according to the knowledge graph?

**Tools used:** The agent called `03 - Graph Retrieval` with `spring-boot`, but that search returned no result. It then tried `spring`, which worked.

**Information found:** The graph returned five topics linked to Spring Boot: Java, Object-Oriented Programming, REST API, JDBC, and MVC Architecture.

**Agent's answer:** The agent listed all five topics, explained why they matter, and suggested an order for learning them. It named the project's learning graph as its source. The complete answer is in `Test 2.pdf`.

**My evaluation:** The agent found the correct information after trying again. This was a good result, but it also showed a weakness: the tool did not recognize `spring-boot` as the same topic as `spring`. Another thing to keep in mind is that the graph lists topics to learn before Spring Boot, but it does not give an exact order for all five. That order was the agent's own suggestion.

## Test 3: Combined Vector and Graph Search

**Question:** I already know Java and SQL. I want to learn Spring Boot. What other concepts should I study first, and can you explain how they relate to Spring Boot using the course material?

**Tools used:** The agent used both `02 - Vector Retrieval` and `03 - Graph Retrieval` several times. Its first graph search for `spring-boot` failed, but its next search for `spring` worked. Later, three vector searches failed because Voyage AI received too many requests.

**Information found:** The agent found Spring Boot's five linked topics in the graph. It also retrieved useful course texts about Spring Boot, OOP, MVC, REST, HTTP, JDBC, SQL, and Java.

**Agent's answer:** Since the student already knew Java and SQL, the agent focused on OOP, REST API, JDBC, and MVC Architecture. It explained how they connect to Spring Boot and included references to the course material and knowledge graph. The complete answer is in `Test 3.pdf`.

**My evaluation:** The answer was useful and took the student's existing knowledge into account. It also showed that the agent could use both types of search together. However, the Voyage AI rate limit caused three tool calls to fail. The agent still answered using information it had already found, but those errors could become a bigger problem with more users or more questions.

## Overall Evaluation

The project shows that vector search and graph search work well together. Vector search helps the agent find relevant explanations, while the graph shows which topics are connected. Claude was able to use both to answer questions about software development.

There are still a few things I would improve. The knowledge base only has eight short texts, so it cannot cover every programming question. I would also make topic names easier to match, so both `spring` and `spring-boot` work. Finally, I would add better handling of API rate limits to avoid failed searches.

Overall, the system works as a small RAG prototype, and the tests show both what it does well and where it needs improvement.
