import logging
import re
from typing import List, Dict, Any, Optional
from sqlalchemy import text
from sqlalchemy.orm import Session
from api.models import engine
from data.schema_context import SCHEMA_CONTEXT
from prompts.sql_prompts import SQL_PROMPT
from langchain.chat_models import ChatOpenAI
from api.config import get_settings

logger = logging.getLogger(__name__)
settings = get_settings()

class QueryTools:
    """
    Tools for executing natural language queries against the database.
    Includes security validation to prevent destructive operations.
    """
    
    def __init__(self):
        self.llm = ChatOpenAI(
            openai_api_key=settings.openai.api_key,
            model_name=settings.openai.model,
            temperature=0
        )
    
    async def query_database(self, question: str) -> Dict[str, Any]:
        """
        Translates a natural language question into SQL and executes it.
        
        Args:
            question: The user's question (e.g., "How many accidents in 2024?")
            
        Returns:
            Dict with 'success', 'data' (list of dicts), 'sql' (generated query), or 'error'.
        """
        try:
            # 1. Generate SQL
            prompt = SQL_PROMPT.format(schema_context=SCHEMA_CONTEXT, question=question)
            response = self.llm.predict(prompt)
            sql_query = response.strip().replace("```sql", "").replace("```", "")
            
            # 2. Validate SQL (Security Check)
            if not self._is_safe_sql(sql_query):
                return {
                    "success": False,
                    "error": "Security Alert: Generated query contains forbidden keywords (UPDATE, DELETE, DROP, etc.)",
                    "sql": sql_query
                }
                
            if "CANNOT_ANSWER" in sql_query:
                return {
                    "success": False,
                    "error": "I cannot answer this question with the available data.",
                    "sql": sql_query
                }

            # 3. Execute SQL
            logger.info(f"Executing generated SQL: {sql_query}")
            
            with Session(engine) as db:
                result = db.execute(text(sql_query))
                
                # Get column names
                columns = result.keys()
                
                # Fetch all rows
                rows = result.fetchall()
                
                # Convert to list of dicts
                data = [dict(zip(columns, row)) for row in rows]
                
                return {
                    "success": True,
                    "data": data,
                    "sql": sql_query,
                    "count": len(data)
                }
                
        except Exception as e:
            logger.error(f"Error in query_database: {e}")
            return {
                "success": False,
                "error": str(e)
            }

    def _is_safe_sql(self, sql: str) -> bool:
        """
        Validates that the SQL query is read-only.
        """
        sql_upper = sql.upper()
        
        # Must start with SELECT
        if not sql_upper.strip().startswith("SELECT"):
            return False
            
        # Forbidden keywords
        forbidden = ["UPDATE", "DELETE", "DROP", "INSERT", "ALTER", "TRUNCATE", "EXEC", "MERGE", "GRANT", "REVOKE"]
        
        for word in forbidden:
            # Check for whole words only
            if re.search(r'\b' + word + r'\b', sql_upper):
                return False
                
        return True
