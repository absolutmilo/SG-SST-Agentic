import bcrypt

password = b"123456"
salt = bcrypt.gensalt()
hashed = bcrypt.hashpw(password, salt)
print(f"HASH:{hashed.decode('utf-8')}")
