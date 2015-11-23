"""
Use the Bing Search API to get the most recent news article about a candidate.
Created by jennhuang on 10/21/2015.
"""

import urllib
import urllib2
import json
 
API_KEY = '4ORqdbQRr/FQTkttrengT8432RKxKlkLrcPAND1zjOo'

def main():
    # TODO(jennhuang): Given a list of candidates, perform a search query for each candidate.    
    bing_search("hillary clinton")
 
def bing_search(query):
    escaped_query = urllib.quote(query)
    # create credential for authentication
    credentials = (':%s' % API_KEY).encode('base64')[:-1]
    auth = 'Basic %s' % credentials
    url = 'https://api.datamarket.azure.com/Bing/Search/v1/News'+'?Query=%27'+ escaped_query+'%27&$top=20&$format=json'
    request = urllib2.Request(url)
    request.add_header('Authorization', auth)
    request_opener = urllib2.build_opener()
    response = request_opener.open(request) 
    response_data = response.read()
    json_result = json.loads(response_data)
    result_list = json_result['d']['results']
    for article in result_list:
        # TODO(jennhuang): Instead of printing out the articles, put the articles in the database
        print article['Title']
        print article['Description']
        print article['Source']
        print article['Url']
 
if __name__ == "__main__":
    main()