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
