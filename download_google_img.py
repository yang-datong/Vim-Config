#!/usr/local/bin/python3.9
import requests
from bs4 import BeautifulSoup
import urllib.request
import os

# set the search query and the number of images to download
search_query = 'atomu'
num_images = 10

# create a folder to store the downloaded images
if not os.path.exists(search_query):
    os.makedirs(search_query)

# set the parameters for the search URL
params = {
    'q': search_query,
    'tbm': 'isch',
    'tbs': 'isz:lt,islt:qsvga',
    'ijn': '0'
}

# get the search page
search_url = 'https://www.google.com/search?' + urllib.parse.urlencode(params)
response = requests.get(search_url)

# parse the HTML content using BeautifulSoup
soup = BeautifulSoup(response.content, 'html.parser')

# find all the img tags in the page
img_tags = soup.find_all('img')

# extract the URLs of the images
image_urls = [img['src'] for img in img_tags]

# download the images
for i, url in enumerate(image_urls):
    if i >= num_images:
        break
    try:
        # modify the URL to download a larger version of the image
        url = url.replace('w=200', 'w=1920')
        url = url.replace('h=200', 'h=1080')
        response = requests.get(url)
        file_name = os.path.join(search_query, search_query + '_' + str(i+1) + '.jpg')
        with open(file_name, 'wb') as f:
            f.write(response.content)
        print('Downloaded image ' + str(i+1) + ' of ' + str(num_images))
    except:
        print('Error downloading image ' + str(i+1))

