Parse.Cloud.define("add_user_survey_data_to_polls", function(request, response) {
    var query = new Parse.Query(Parse.User);
    query.equalTo("objectId", request.params.user);  
    query.find({
        success: function(user) {
            var surveyAnswers = user[0].get("surveyAnswers");
            var Issue = Parse.Object.extend("Issue");
            var query = new Parse.Query(Issue);
            query.find()
                .then(function(results) {
                    var issuesToSave = [];
                    for (var i = 0; i < results.length; i++) {
                        var promise = new Parse.Promise();
                        var issueId = results[i].id;
                        var userPositionOnIssue = surveyAnswers[issueId];
                        var count = 0;
                        if (userPositionOnIssue < 2.5) {
                            count = results[i].get("usersAgainst");
                            count = (count == undefined) ? 1 : count + 1;
                            results[i].set("usersAgainst", count);
                        }
                        else if (userPositionOnIssue < 3.5) {
                            count = results[i].get("usersNeutral");
                            count = (count == undefined) ? 1 : count + 1;
                            results[i].set("usersNeutral", count);   
                        }
                        else {
                            count = results[i].get("usersFor");
                            count = (count == undefined) ? 1 : count + 1;
                            results[i].set("usersFor", count);
                        }
                        issuesToSave.push(results[i]);
                    }

                    Parse.Object.saveAll(issuesToSave, {
                        useMasterKey: true,
                        success: function(list) {
                            console.log("list length " + list.length);
                            promise.resolve(list.length);
                        },
                        error: function() {
                            promise.reject();
                        }
                    });
                    return promise; 
                }).then(function(length) {
                    response.success(length);
                }, function() { 
                    response.error("Error: could not update user polls from survey data");
                });
        },
        error: function(error) {
            alert("Error: " + error.code + " " + error.message);
            response.error("Error: " + error.code + " " + error.message);
        }
    });    
});