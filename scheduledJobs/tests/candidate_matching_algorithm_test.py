# Tests the get_survey_candidates function on Cloud Code

import json,httplib

connection = httplib.HTTPSConnection('api.parse.com', 443)
connection.connect()

# Get all the candidates
connection.request('GET', '/1/classes/Candidate', '', {
       "X-Parse-Application-Id": "K1OX77eW0lBtAm8TSc8HYHzvfe7KkM4qi9vwtCBF",
       "X-Parse-REST-API-Key": "QCArbvRm6jUYwEEcSNNUT2G4nTTex4qV5KbrJHlS"
     })
result = json.loads(connection.getresponse().read())

democrats = {}
republicans = {}
other = {}

for candidate in result["results"]:
	if candidate["PartyAffiliation"] == "Democratic Party":
		democrats[candidate["lastName"]] = 1
	elif candidate["PartyAffiliation"] == "Republican Party":
		republicans[candidate["lastName"]] = 1
	else:
		other[candidate["lastName"]] = 1

testNumber = 0

# If there are fewer than 6 candidates (because candidates dropped out), then
# reduce the number of expected candidates to be with certain viewpoints to 1
if len(result["results"]) < 6:
	max = 1
else:
	max = 3

# Users with conservative viewpoints should be highly compatible with Republicans
# and least compatible with Democrats 
print "Test#" + str(testNumber) + ": User with conservative viewpoints"

connection.request('POST', '/1/functions/get_survey_candidates', json.dumps(
		{"user": "1JdWPLEYml"}
     ), {
       "X-Parse-Application-Id": "K1OX77eW0lBtAm8TSc8HYHzvfe7KkM4qi9vwtCBF",
       "X-Parse-REST-API-Key": "QCArbvRm6jUYwEEcSNNUT2G4nTTex4qV5KbrJHlS",
       "Content-Type": "application/json"
     })
result = json.loads(connection.getresponse().read())

# First few candidates should be Republicans
for i in range(0, max):
	assert result["result"][i]["lastName"] in republicans, "The first %r candidate(s) are not Republicans. %r is not a Republican" % (max, result["result"][i]["lastName"])
print "Passed. The first " + str(max) + " candidate(s) are Republicans."

# Last few candidates should be Democrats
for i in range(len(result["result"])-max, len(result["result"])):
	assert result["result"][i]["lastName"] in democrats or result["result"][i]["lastName"] in other, "The last %r candidate(s) are not Democrats. %r is not a Democrat" % (max, result["result"][i]["lastName"])
print "Passed. The last " + str(max) + " candidate(s) are Democrats."

testNumber += 1

# Users with liberal viewpoints should be highly compatible with Democrats
# and least compatible with Republicans 
print "Test#" + str(testNumber) + ": User with liberal viewpoints"
connection.request('POST', '/1/functions/get_survey_candidates', json.dumps(
		{"user": "cntcD1OQo0"}
     ), {
       "X-Parse-Application-Id": "K1OX77eW0lBtAm8TSc8HYHzvfe7KkM4qi9vwtCBF",
       "X-Parse-REST-API-Key": "QCArbvRm6jUYwEEcSNNUT2G4nTTex4qV5KbrJHlS",
       "Content-Type": "application/json"
     })
result = json.loads(connection.getresponse().read())

# First few candidates should be Democrats or Green Party
for i in range(0, max):
	assert result["result"][i]["lastName"] in democrats or result["result"][i]["lastName"] in other, "The first %r candidate(s) are not Democrats. %r is not a Democrat" % (max, result["result"][i]["lastName"])
print "Passed. The first " + str(max) + " candidate(s) are Democrats or Green Party."

# Last few candidates should be Republicans
for i in range(len(result["result"])-max, len(result["result"])):
	assert result["result"][i]["lastName"] in republicans, "The last %r candidate(s) are not Republicans. %r is not a Republican" % (max, result["result"][i]["lastName"])
print "Passed. The last " + str(max) + " candidate(s) are Republicans."

print "All tests passed!"

