import requests
    
r = requests.get("http://0.0.0.0:8080", stream = True)

print(r.status_code)
print(r.reason)
print(r.raw.read())
#print(r.raw.read(10))
#print(r.status_code)
#print(f"the encoding standard: {r.encoding}")
#print(f"this is the url: {r.url}")
#print(f"this is the response: {r.content}")
