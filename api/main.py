import requests
import json

url = 'https://apis.paralleldots.com/v4/sentiment'
myobj = {'text': 'It was a good experience',
            'api_key':'03guykFK7X7r8Xw7ABcSaIQjiAfgoir91cKtbANGCXU',
            'lang_code':'en'}



r = requests.post(url, data = myobj)

r = r.json()
print(r)
print(type(r))
print(json.dumps(r))

