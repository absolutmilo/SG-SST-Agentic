"""
Prompt templates for SQL generation.
"""

from langchain.prompts import PromptTemplate

SQL_GENERATION_TEMPLATE = """{schema_context}

USER QUESTION: {question}

INSTRUCTIONS:
1. Write a T-SQL query to answer the question.
2. Only return the SQL query, no markdown, no explanations.
3. If the question cannot be answered with the schema, return "SELECT 'CANNOT_ANSWER' as error".
4. Always use aliases for tables (e.g. EMPLEADO e).
5. If asking for a count, use COUNT(*).

SQL QUERY:"""

SQL_PROMPT = PromptTemplate(
    input_variables=["schema_context", "question"],
    template=SQL_GENERATION_TEMPLATE
)

SQL_INSERTION_TEMPLATE = """{schema_context}

CONSTRAINTS & RULES (CRITICAL):
{constraints_context}

USER REQUEST: {question}

INSTRUCTIONS:
1. Write a T-SQL query to INSERT data based on the user request.
2. **VALIDATE** all values against the "CONSTRAINTS & RULES" section above.
   - If a value is not allowed (e.g. wrong 'Tipo' or 'Estado'), DO NOT invent one. Use a valid one or return an error.
   - If a Foreign Key is required (e.g. id_sede, id_empleado), you MUST subquery it or use a variable if not provided.
     Example: `(SELECT TOP 1 id_sede FROM SEDE WHERE Nombre LIKE '%Bogota%')`
3. If information is missing (e.g. user didn't specify 'Tipo'), return "MISSING_INFO: <what is missing>" instead of SQL.
4. Only return the SQL query or the MISSING_INFO message. No markdown.

SQL QUERY:"""

SQL_INSERTION_PROMPT = PromptTemplate(
    input_variables=["schema_context", "constraints_context", "question"],
    template=SQL_INSERTION_TEMPLATE
)
