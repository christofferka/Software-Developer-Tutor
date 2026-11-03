# Agent configuration

- Name: **Software Development Tutor**
- Builder: **n8n Agents Builder** (not just a workflow AI Agent node)
- LLM provider: **Anthropic**
- Model observed during development: **`claude-sonnet-4-6`**. Verify the model shown in the final saved agent before submitting.
- Tools: `02 - Vector Retrieval` (`question: string`) and `03 - Graph Retrieval` (`conceptId: string`)
- Tool behaviors: see `tool-descriptions.md`
- System instructions: see `system-prompt.md`
- Embedding provider: Voyage AI using `voyage-4-lite`, 1024 dimensions, stored in Neo4j
- User interface: n8n Agents chat/preview
- Credentials: stored in n8n credential store; **not** included in repository

## Required evidence
Include a screenshot of the agent showing its model and both connected tools, plus actual tool-call traces and answers for each of the three tests.

## Important
These are project notes based on configuration discussed during development. Confirm that names, published agent state and model match what is visible in your final n8n project.
