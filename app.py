import os
from flask import Flask, send_file
import json
import logging
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

options = Options()
options.add_argument('--headless')
options.add_argument("--disable-gpu")
options.add_argument("--disable-dev-shm-usage")
options.add_argument("--no-sandbox")

app = Flask(__name__)


@app.route('/', methods=['GET'])
def home():
    driver = webdriver.Chrome(chrome_options=options)
    driver.get('https://www.google.com')
    driver.save_screenshot("screenshot.png")

    return send_file("screenshot.png", mimetype='image/png')


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 5000)))

