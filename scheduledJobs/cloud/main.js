require("cloud/candidate_matching_algorithm.js")
require("cloud/newsfeed_algorithm.js")
require("cloud/survey_to_polls.js")
require("cloud/twitterpicture.js")
var thumbnail = require("cloud/create_thumbnail.js")

// Bing Search API key and authentication
API_KEY = "Cfd+0huY6d7Ekhz04lEXQfJBr2jt5AS3Oi323X8TtV4";
BASE_64_ENCODED_API_KEY = "OkNmZCswaHVZNmQ3RWtoejA0bEVYUWZKQnIyanQ1QVMzT2kzMjNYOFR0VjQ="
AUTH = "Basic " + BASE_64_ENCODED_API_KEY;

// Updates the Newsfeed table with the top 5 news article related to the candidate
// Uses the Bing Search API to get the news
Parse.Cloud.job("pull_news", function(request, response) {
	// Retrieve all the candidates
	var Candidate = Parse.Object.extend("Candidate");
	var query = new Parse.Query(Candidate);

	// Parse cannot get unique values on columns so the alternative
	// is to query all the values and search for distinct values. 
	query.find({
	  success: function(results) {
		alert("Successfully retrieved " + results.length);
		var candidateNames = [];
		for (var i = 0; i < results.length; i++) {
			var object = results[i];
			// Check that we haven't updated the news for this candidate yet. 
			var candidateFirstAndLast = object.get('firstName') + " " + object.get('lastName');
			if (candidateNames.indexOf(candidateFirstAndLast) == -1) {
				candidateNames.push(candidateFirstAndLast);

				// Bing Search API URL to get the top 5 news results for a query
				var formatted_url = 'https://api.datamarket.azure.com/Bing/Search/v1/News?Query=%27'+object.get('firstName')+ '%20' +object.get('lastName') +'%27&$top=5&$format=json';

				// Make a GET request to the Bing Search API 
				Parse.Cloud.httpRequest({
					url: formatted_url,
					headers: {
						'Authorization': AUTH,
					},
					success: function(httpResponse) {
						var json_result = JSON.parse(httpResponse.text);
						var result_list = json_result.d.results;

						for (var article in result_list) {
							// Obtain the candidate name and remove the space between the first and last name
							// ex) URL: https://api.datamarket.azure.com/Data.ashx/Bing/Search/v1/News?Query='Jeb Bush'&$skip=0&$top=1 
							// will be JebBush 
							var candidate = /.*Query='([a-zA-z' ]*)'.*/.exec(result_list[article].__metadata.uri)[1].replace(/\s+/g, '');
							
							// Only save the news article if it doesn't exist in the table already 
							var NewsFeed = Parse.Object.extend("Newsfeed");
							var checkDuplicateQuery = new Parse.Query(NewsFeed);
							checkDuplicateQuery.equalTo("url", result_list[article].Url);

							// Create anonymous function to pass the article to asynchronous function 
							(function(article){
								checkDuplicateQuery.find({
								  success: function(duplicateResults) {
									if (duplicateResults.length == 0) {
										var NewsFeed = Parse.Object.extend("Newsfeed");
										var newsFeed = new NewsFeed();

										newsFeed.set("candidateID", candidate);
										newsFeed.set("title", result_list[article].Title);
										newsFeed.set("summary", result_list[article].Description);
										newsFeed.set("url", result_list[article].Url);
										newsFeed.set("source", result_list[article].Source);
										newsFeed.set("date", new Date(result_list[article].Date));

										// TODO: move save newsfeed back to here
										thumbnail.setThumbnailandSaveNewsfeed(newsFeed, result_list[article].Title, candidate); 							    	
									}
								  },
								  error: function(error) {
									alert("Error: " + error.code + " " + error.message);
								  }
								});
							})(article);						
						}
					},
					error: function(httpResponse) {
					alert('Request failed with response code ' + httpResponse.status);
					}
				});
			} 
		}
	  //response.success("Ran scheduled job.");
	  },
	  error: function(error) {
		alert("Error: " + error.code + " " + error.message);
	  }
	});

});

// Deletes Bing Sarch related news items that are older than 48 hours in Newsfeed table
Parse.Cloud.job("delete_old_news", function(request, response) {
	var NewsFeed = Parse.Object.extend("Newsfeed");
	var query = new Parse.Query(NewsFeed);

	// Deleting Bing Search related news items and ignoring Tweets
	query.notEqualTo("source", "Twitter");

	// News older than 48 hours gets deleted
	var date = new Date();
	date.setDate(date.getDate() - 2);
	query.lessThan("date", date);

	query.find({
	  success: function(results) {
		alert("Successfully retrieved " + results.length + " old news items.");
		for (var i = 0; i < results.length; i++) {
		  var object = results[i];
			object.destroy({
			  success: function(object) {
				// The object was deleted from the Parse Cloud.
			  },
			  error: function(object, error) {
				// The delete failed.
				alert("Error: " + error.code + " " + error.message);
			  }
			});
		}
	  },
	  error: function(error) {
		alert("Error: " + error.code + " " + error.message);
	  }
	});
});
