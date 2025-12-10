import sys
sys.path.insert(0, 'backend')

try:
    print("1. Importing form_catalog...")
    from api.services import form_catalog
    print("   ✓ Module imported")
    
    print("2. Getting catalog...")
    catalog = form_catalog.get_form_catalog()
    print(f"   ✓ Catalog loaded: {len(catalog)} forms")
    
    print("\n3. Forms in catalog:")
    for form_id in catalog.keys():
        print(f"   - {form_id}")
        
except Exception as e:
    print(f"   ✗ ERROR: {e}")
    import traceback
    traceback.print_exc()
