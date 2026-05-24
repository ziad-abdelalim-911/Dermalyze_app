import requests
import json

base_url = "https://dermalyze-backend-final-main-production.up.railway.app/api"

# Login as patient (try creating one or use common dummy)
def register_and_login(role="patient"):
    email = f"test_{role}_999@test.com"
    pw = "password123"
    
    # Register
    reg_res = requests.post(f"{base_url}/auth/register", json={
        "name": f"Test {role}",
        "email": email,
        "password": pw,
        "role": role
    })
    
    # Login
    log_res = requests.post(f"{base_url}/auth/login", json={
        "email": email,
        "password": pw
    })
    
    if log_res.status_code == 200:
        return log_res.json()
    return None

def test_endpoints():
    doctor_data = register_and_login("doctor")
    patient_data = register_and_login("patient")
    
    if not doctor_data or not patient_data:
        print("Login failed")
        return
        
    doc_token = doctor_data['token']
    doc_id = doctor_data['user']['_id']
    
    pat_token = patient_data['token']
    pat_id = patient_data['user']['_id']
    
    print(f"Doctor ID: {doc_id}")
    print(f"Patient ID: {pat_id}")
    
    # Test patient medications
    headers = {"Authorization": f"Bearer {pat_token}"}
    
    # Try 1: patient/$pat_id/medications
    res1 = requests.get(f"{base_url}/patient/{pat_id}/medications", headers=headers)
    print(f"GET patient/.../medications: {res1.status_code} {res1.text[:100]}")
    
    # Try 2: patients/$pat_id/medications
    res2 = requests.get(f"{base_url}/patients/{pat_id}/medications", headers=headers)
    print(f"GET patients/.../medications: {res2.status_code} {res2.text[:100]}")

    # Try 3: medications
    res3 = requests.get(f"{base_url}/medications", headers=headers)
    print(f"GET /medications: {res3.status_code} {res3.text[:100]}")

    # Test doctor updating patient status
    doc_headers = {"Authorization": f"Bearer {doc_token}"}
    
    # Link patient to doctor first?
    requests.post(f"{base_url}/link-doctor", headers=headers, json={"doctorCode": doctor_data['user'].get('doctorCode', '')})
    
    # Try 1: patients/$pat_id/status
    res4 = requests.put(f"{base_url}/patients/{pat_id}/status", headers=doc_headers, json={"status": "Stable"})
    print(f"PUT patients/.../status: {res4.status_code} {res4.text[:100]}")
    
    # Try 2: doctor/patients/$pat_id/status
    res5 = requests.put(f"{base_url}/doctor/patients/{pat_id}/status", headers=doc_headers, json={"status": "Stable"})
    print(f"PUT doctor/patients/.../status: {res5.status_code} {res5.text[:100]}")
    
    # Try 3: doctor/patient/$pat_id/status
    res6 = requests.put(f"{base_url}/doctor/patient/{pat_id}/status", headers=doc_headers, json={"status": "Stable"})
    print(f"PUT doctor/patient/.../status: {res6.status_code} {res6.text[:100]}")

    # Test analysis endpoint
    # Try 1: analysis/$pat_id
    res7 = requests.post(f"{base_url}/analysis/{pat_id}", headers=headers, files={"image": ("test.jpg", b"123", "image/jpeg")})
    print(f"POST analysis/...: {res7.status_code} {res7.text[:100]}")
    
    # Try 2: patient/{pat_id}/analysis
    res8 = requests.post(f"{base_url}/patient/{pat_id}/analysis", headers=headers, files={"image": ("test.jpg", b"123", "image/jpeg")})
    print(f"POST patient/.../analysis: {res8.status_code} {res8.text[:100]}")
    
    # Try 3: patients/{pat_id}/analysis
    res9 = requests.post(f"{base_url}/patients/{pat_id}/analysis", headers=headers, files={"image": ("test.jpg", b"123", "image/jpeg")})
    print(f"POST patients/.../analysis: {res9.status_code} {res9.text[:100]}")

if __name__ == "__main__":
    test_endpoints()
