from fastapi import FastAPI
import random
import requests
app = FastAPI()

@app.get('/hi')
def hi():
    return {'status': 'ok'}


@app.get('/lotto')
def lotto():
    return {
        '1등 예상번호는': random.sample(range(1, 46), 6)
    }

@app.get('/gogogo')
def gogogo():
    bot_token = '8201997744:AAETH7OMGynmxP-klSDw_BWAVyyMSlGRIdg'
    URL = f'https://api.telegram.org/bot{bot_token}'
    body = {
        'chat_id': '7481281400',
        'text': '이 메시지는 서버가 보냄', 
    }
    requests.get(URL + '/sendMessage', body)
    return {'status': 'gogogo'}