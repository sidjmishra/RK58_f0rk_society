import requests 
from chalice import Chalice
import json
# from paralleldots import set_api_key, get_api_key
# set_api_key("03guykFK7X7r8Xw7ABcSaIQjiAfgoir91cKtbANGCXU")
app = Chalice(app_name='helloworld')
url = 'https://apis.paralleldots.com/v4/sentiment'


@app.route('/')
def index():
    return {'hello': 'world'}

@app.route('/get_sentiment',methods=['POST'],content_types=['application/json'])
def get_sentiment():
    request_body = app.current_request.json_body
    print(request_body["review"])
    myobj = {'text': request_body["review"],
            'api_key':'03guykFK7X7r8Xw7ABcSaIQjiAfgoir91cKtbANGCXU',
            'lang_code':'en'}
    r = requests.post(url, data = myobj)
    return json.dumps(r.json())

# The view function above will return {"hello": "world"}
# whenever you make an HTTP GET request to '/'.
#
# Here are a few more examples:
#
@app.route('/hello/{name}')
def hello_name(name):
   # '/hello/james' -> {"hello": "james"}
    print(name)
    myobj = {'text': name,
            'api_key':'03guykFK7X7r8Xw7ABcSaIQjiAfgoir91cKtbANGCXU',
            'lang_code':'en'}
    r = requests.post(url, data = myobj)
    return json.dumps(r.json())
#

# @app.route('/users', methods=['POST'])
# def create_user():
#     # This is the JSON body the user sent in their POST request.
#     user_as_json = app.current_request.json_body
#     # We'll echo the json body back to the user in a 'user' key.
#     return {'user': user_as_json}
#
# See the README documentation for more examples.
#
