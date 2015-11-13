/*
* Get a list of newsfeed items
*
* Input: String, user's objectId
*   Ex) {"user": "gBAz26cAHK"}
* Output: JSON with an unsorted list of newsfeed items
* 
* Usage examples:
* Through the API console (or REST API):
* 1) Go to Parse.com -> Core > API Console
* 2) Endpoint: POST functions/get_newsfeed
* 3) Request body: {"user": "gBAz26cAHK"}
*
* Example output:
* {
    "result": [
        {
            "date": {
                "__type": "Date",
                "iso": "2015-11-11T19:41:09.000Z"
            },
            "favoriteCount": 2296,
            "retweetCount": 1276,
            "source": "Twitter",
            "summary": "My closing statement at last night's #GOPDebate.",
            "twitterUsername": "RealBenCarson",
            "url": "https://t.co/qdJVC2RbeN"
        },
        {
            "date": {
                "__type": "Date",
                "iso": "2015-11-10T01:34:54.000Z"
            },
            "source": "Independent Political Report",
            "summary": "I’m just back from another whirlwind tour, this time in Texas. I wanted to share with you some of the latest remarkable moments that leave me ever more humbled and honored to be part of this peaceful uprising. Across the Lone Star State, everyday heroes ...",
            "title": "Jill Stein Reports From Texas",
            "url": "http://www.independentpoliticalreport.com/2015/11/jill-stein-reports-from-texas/"
        },
        // some more newsfeed items
    ]
* } 
*/

Parse.Cloud.define("get_newsfeed", function(request, response) {
    // Get the candidate object IDs
    var Candidate = Parse.Object.extend("Candidate");
    var query = new Parse.Query(Candidate);

    (function(request){
        query.find({
            success: function(results) {
                idToName = {}
                for (var i = 0; i < results.length; i++) {
                    var object = results[i];
                    idToName[object.id] = object.get('firstName')+object.get('lastName');
                }

                (function(idToName){
                    var query = new Parse.Query(Parse.User);
                    query.equalTo("objectId", request.params.user); 
                    query.find({
                        success: function(results) {
                            var candidates = results[0].get("candidatesFollowed");
                            var candidateNames = [];
                            for (var i = 0; i < candidates.length; i++) {
                                candidateNames.push(idToName[candidates[i]]);
                            }
                            
                            var Newsfeed = Parse.Object.extend("Newsfeed");
                            var query = new Parse.Query(Newsfeed);
                            query.containedIn("candidateID", candidateNames);

                            query.find({
                                success: function(results) { 
                                    console.log("Successfully retrieved " + results.length + " newsfeed items.");
                                    var items = []
                                    for (var i = 0; i < results.length; i++) {
                                        var object = results[i];
                                        var summary = object.get('summary').replace(/\n/g, '');
                                        var item = {
                                            "source": object.get('source'),
                                            "title": object.get('title'),
                                            "summary": summary,
                                            "url": object.get('url'),
                                            "date": object.get('date'),
                                            "favoriteCount": object.get('favoriteCount'),
                                            "retweetCount": object.get('retweetCount'),
                                            "twitterUsername": object.get('twitterUsername')
                                        }
                                        if(object.get('source') === "Twitter") {
                                            var url = /https:\/\/t.co\/[a-zA-z0-9]*/.exec(object.get('summary'));
                                            if (url != null) {
                                                item["url"] = url[0];
                                                item["summary"] = item["summary"].replace(url, "");
                                            }
                                        }
                                        items.push(item);
                                    }
                                    // Return array of newsfeed items in JSON
                                    response.success(items);
                                }, 
                                error: function(error) {
                                    alert("Error: " + error.code + " " + error.message);
                                }
                            });
                        }, 
                        error: function(error) {
                            alert("Error: " + error.code + " " + error.message);
                        }
                    })
                }) (idToName);
          },
          error: function(error) {
            alert("Error: " + error.code + " " + error.message);
          }
        });
    })(request);
})