Parse.Cloud.define("getNewsFeed", function(request, response) {
    var candidates = [];
    var user = new Parse.Query(Parse.User);
    user.equalTo("objectId", request.params.user);
    user.find({
        success: function(user_result) {
            var candidateObjectIds = user_result[0].get("candidatesFollowed");
            for (var i = 0; i < candidateObjectIds.length; i++) {
                var candidate = new Parse.Query(Parse.Candidate);
                candidate.equalTo("objectId", candidateObjectIds[i]);
                candidate.find({
                    success: function(candidate_result) {
                        var firstName = candidate_result[0].get("firstName");
                        var secondName = candidate_resul[0].get("secondName");
                        candidates.push(firstName + secondName);
                    },
                    error: function(error) {
                        // candidate not found
                        alert("Error:");
                    }
                });
            }

        },
        error: function(error) {
            alert("Error: " + error.code + " " + error.message);
            response.error("Error: " + error.code + " " + error.message);
        }
    });
    
});