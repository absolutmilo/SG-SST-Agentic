import sys
import os
from sqlalchemy import text

# Add parent directory to path to import api modules
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from api.models import engine
from api.utils.security import get_password_hash

def add_password_column():
    print("Checking if Password_Hash column exists...")
    with engine.connect() as connection:
        # Check if column exists
        result = connection.execute(text(
            "SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS "
            "WHERE TABLE_NAME = 'USUARIOS_AUTORIZADOS' AND COLUMN_NAME = 'Password_Hash'"
        ))
        exists = result.scalar() > 0
        
        if exists:
            print("Password_Hash column already exists.")
        else:
            print("Adding Password_Hash column...")
            connection.execute(text(
                "ALTER TABLE USUARIOS_AUTORIZADOS ADD Password_Hash NVARCHAR(255) NULL"
            ))
            connection.commit()
            print("Column added.")
            
        # Update existing users with default password '123456'
        print("Updating existing users with default password '123456'...")
        default_hash = get_password_hash("123456")
        
        connection.execute(text(
            "UPDATE USUARIOS_AUTORIZADOS SET Password_Hash = :hash WHERE Password_Hash IS NULL"
        ), {"hash": default_hash})
        connection.commit()
        print("Users updated.")
        
        # Make column not null
        # Note: We can only do this if all rows have a password
        # connection.execute(text(
        #     "ALTER TABLE USUARIOS_AUTORIZADOS ALTER COLUMN Password_Hash NVARCHAR(255) NOT NULL"
        # ))
        # connection.commit()
        # print("Column set to NOT NULL.")

if __name__ == "__main__":
    try:
        add_password_column()
        print("✅ Database updated successfully!")
    except Exception as e:
        print(f"❌ Error updating database: {e}")
