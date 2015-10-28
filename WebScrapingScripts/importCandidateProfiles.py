import requests
import re
import pprint

user_agent = {'User-agent': 'Mozilla/5.0'}

#50 = marco rubio, 40 = hillary clinton -- insert numbers or url's for each candidate 
ids = ['50', '40']

for id in ids:
	page = requests.get('http://presidential-candidates.insidegov.com/l/' + id, headers=user_agent)
	print(page)
	match = re.findall(r'<td class=\'fname\'>(.*)<\/td>\n*\s*<td class=\'fdata\'>([a-zA-Z\s,\d()\'"]*)<\/td>', page.content)
	match.extend(re.findall(r'<td class=\'fname\'>(.*)<\/td>\n*\s*<td class=\'fdata\'><a href=.*(http.*)(?:\'|").*rel.*<\/td>', page.content))
	pprint.pprint(match)

