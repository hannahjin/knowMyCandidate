API_KEY = "Cfd+0huY6d7Ekhz04lEXQfJBr2jt5AS3Oi323X8TtV4";
BASE_64_ENCODED_API_KEY = "OkNmZCswaHVZNmQ3RWtoejA0bEVYUWZKQnIyanQ1QVMzT2kzMjNYOFR0VjQ="
AUTH = "Basic " + BASE_64_ENCODED_API_KEY;

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
	      	// not in array 
	      	var candidateFirstAndLast = object.get('firstName') + " " + object.get('lastName');
	      	if (candidateNames.indexOf(candidateFirstAndLast) == -1) {
	      		candidateNames.push(candidateFirstAndLast);
	      		var formated_url = 'https://api.datamarket.azure.com/Bing/Search/v1/News?Query=%27'+object.get('firstName')+ '%20' +object.get('lastName') +'%27&$top=5&$format=json';

				Parse.Cloud.httpRequest({
					url: formated_url,
					headers: {
				    	'Authorization': AUTH,
				    },
					success: function(httpResponse) {

						var json_result = JSON.parse(httpResponse.text);
					    var result_list = json_result.d.results;

					    for (var article in result_list) {
							var NewsFeed = Parse.Object.extend("Newsfeed");
							var newsFeed = new NewsFeed();

							// Obtain the candidate name and remove the space between the first and last name
							// ex) URL: https://api.datamarket.azure.com/Data.ashx/Bing/Search/v1/News?Query='Jeb Bush'&$skip=0&$top=1 
							// will be JebBush 
							var candidate = /.*Query='([a-zA-z ]*)'.*/.exec(result_list[article].__metadata.uri)[1].replace(/\s+/g, '');
							
					    	newsFeed.save({
							candidateID: candidate,
							title: result_list[article].Title,
							summary: result_list[article].Description,
							url: result_list[article].Url,
							source: result_list[article].Source,
							}, {
							  success: function(newsFeed) {
							  	//alert("Saved news article");
							    // The object was saved successfully.
							  },
							  error: function(newsFeed, error) {
							  	alert("Error: " + error.code + " " + error.message);
							    // The save failed.
							    // error is a Parse.Error with an error code and message.
							  }
							});
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
