import urllib.request

try:
    response = urllib.request.urlopen('http://127.0.0.1:8000/')
    html = response.read().decode('utf-8')
    print("HTML Length:", len(html))
    print("First 500 chars:")
    print(repr(html[:500]))
    print("Does it contain consecutive spaces or newlines outside scripts?")
    # Check if there are any newlines in the first 500 characters
    print("Newlines in first 500 chars:", html[:500].count('\n'))
except Exception as e:
    print("Error:", e)
