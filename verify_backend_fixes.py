import requests
import json

BASE_URL = "http://localhost:8000/api/v1"
LOGIN_URL = f"{BASE_URL}/auth/token"
WORK_PLAN_URL = f"{BASE_URL}/procedures/work-plan-compliance"
MEDICAL_EXAM_URL = f"{BASE_URL}/procedures/medical-exam-compliance"

def login():
    try:
        response = requests.post(
            LOGIN_URL,
            data={"username": "ceo@digitalbulks.com", "password": "123456"},
            headers={"Content-Type": "application/x-www-form-urlencoded"}
        )
        if response.status_code == 200:
            return response.json()["access_token"]
        else:
            print(f"Login failed: {response.status_code} - {response.text}")
            return None
    except Exception as e:
        print(f"Login error: {e}")
        return None

def verify_endpoint(name, url, token):
    print(f"\nTesting {name}...")
    try:
        response = requests.get(
            url,
            headers={"Authorization": f"Bearer {token}"}
        )
        if response.status_code == 200:
            print(f"✅ {name} SUCCESS")
            print(json.dumps(response.json(), indent=2))
            return True
        else:
            print(f"❌ {name} FAILED: {response.status_code}")
            print(response.text)
            return False
    except Exception as e:
        print(f"❌ {name} ERROR: {e}")
        return False

def main():
    print("Starting backend verification...")
    token = login()
    if not token:
        return

    success_work = verify_endpoint("Work Plan Compliance", WORK_PLAN_URL, token)
    success_medical = verify_endpoint("Medical Exam Compliance", MEDICAL_EXAM_URL, token)

    if success_work and success_medical:
        print("\n✅ ALL BACKEND FIXES VERIFIED")
    else:
        print("\n❌ SOME CHECKS FAILED")

if __name__ == "__main__":
    main()
