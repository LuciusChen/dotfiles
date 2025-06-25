# pip3 install beautifulsoup4
# pip3 install Pillow
# pip install pybase64
import re
import time
import base64
import os
import urllib.request
from bs4 import BeautifulSoup
from PIL import Image
from io import BytesIO

filepath_standard = "/Users/lucius/.hammerspoon/Spoons/Emojis.spoon/emojis/png/"
urls = [
    "https://unicode.org/emoji/charts/full-emoji-list.html",
    "https://unicode.org/emoji/charts/full-emoji-modifiers.html",
]


def getI420FromBase64(filename, codec, image_path):
    base64_data = re.sub("^data:image/.+;base64,", "", codec)
    byte_data = base64.b64decode(base64_data)
    image_data = BytesIO(byte_data)
    img = Image.open(image_data)
    t = time.time()
    file = image_path + filename + ".png"
    if os.path.exists(file):
        img.save(file, "PNG")


for url in urls:
    request = urllib.request.Request(url)
    html = urllib.request.urlopen(request)
    soup = BeautifulSoup(html, "html.parser")
    for tr in soup.find_all("tr"):
        tds = tr.find_all("td", {"class": "andr"})
        filename = ""
        if tds:
            unicodes = tr.find("td", {"class": "code"}).find("a")["name"].split("_")
            for unicode in unicodes:
                if unicode != "200d" and unicode != "fe0f":
                    filename = filename + unicode + "-"
            img_src = ""
            if tds[0].find("img"):
                img_src = tds[0].find("img")["src"]
            else:
                img_src = tds[1].find("img")["src"]
            getI420FromBase64(filename[0:-1], img_src, filepath_standard)
