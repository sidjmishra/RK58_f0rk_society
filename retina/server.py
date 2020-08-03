from flask import Flask, request, Response
import jsonpickle
import numpy as np
import cv2
import fastai
from fastai.vision import *
from fastai.metrics import error_rate
from PIL import Image
import torch
import scipy.misc
import torchvision.transforms as T



# Initialize the Flask application
app = Flask(__name__)


# route http posts to this method

@app.route('/', methods=['POST'])
def test():
    # img = Image.open(request.files['file'])
    # print(img)
    img = open_image(request.files['file'])
    # img_tensor = T.ToTensor()(img)
    # img_fastai = Image(img_tensor)

    # # r = request
    # # # convert string of image data to uint8
    # # nparr = np.fromstring(r.data, np.uint8)
    # # # decode image
    # # print(nparr)
    # # img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    # # cv2.imwrite("plane.jpeg", img)
	
    # # i = open_image("plane.jpeg")

    # # do some fancy processing here....

    # #img_fastai = Image(pil2tensor(img, dtype=np.float32).div_(255))
   
    # #print(type(img_fastai))
    # #i = torch.from_numpy(img) 
    # #pil_im = Image.fromarray(img) 
    # #x = pil2tensor(pil_im ,np.float32)
	

    deployed_path = "export"   # If using a deployed model
    
    learn = load_learner(deployed_path)

    label = learn.predict(img)[0]
    print(label)
    # build a response dict to send back to client
    response = {'message': 'Label.{}'.format(label)
                }
    # encode response using jsonpickle

    response_pickled = jsonpickle.encode(response)

    return Response(response=response_pickled, status=200, mimetype="application/json")


app.run(host="0.0.0.0", port=5000)
