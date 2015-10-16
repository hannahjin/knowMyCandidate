import requests
import re
import mechanize
import pprint

user_agent = {'User-agent': 'Mozilla/5.0'}

#insert numbers or url's for each candidate 
ids = ['64', '40']

#append to url if website blocks request (error 403 forbidden)
#googleCache = 'http://webcache.googleusercontent.com/search?q=cache:'

for id in ids:
	br = mechanize.Browser()
	br.set_handle_robots(False)
	page = requests.get('http://presidential-candidates.insidegov.com/l/' + id, headers={'User-Agent': 'Mozilla/5.0'})
	print(page)
	match = re.findall(r'<td colspan=\'2\' class=\'fullrow fdata\'><font size="3"><b>(.*)<\/b><\/font> - <font color=.*<i>(.*)<\/i>', page.content)
	pprint.pprint(match)


# soup = BeautifulSoup(page.content, "html.parser")
# # print(soup.find_all(attrs={"data-id": "301"}))
# print(soup.html.body.table.tbody.find_all('')

# tree = html.fromstring(page.text)
# issues = tree.xpath('/html/body/div[1]/div[2]/div/div/div[4]/div/div[2]/div[1]/div[2]/div[6]/div[2]/section[5]/div[2]/div[2]/div/table/tbody/tr/td/div/div[2]/div[2]/div/div/div/div[2]/table/tbody/tr/td/div/div/div/div[1]/table/tbody/tr[1]
