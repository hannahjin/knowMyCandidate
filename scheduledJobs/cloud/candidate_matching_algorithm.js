/*
* Get a sorted list of candidates with the most similar viewpoints to the user,
* with most compatible candidate first and least compatible candidate last. 
*
* Input: String, user's objectId
*   Ex) {"user": "pcEbh8GpHi"} 
* Output: JSON with a sorted list of candidate object with most compatible candidate first
*   Each candidate object contains
*     candidate: candidate's objectId
*     issues: a sorted list of issue objects with the issue most compatible to the user first
        Each issue object contains:
          compatibility: String 
          issue: String, the issue's objectID in the Issues table
          position: String, the user's position on the issue
          weight: float, the user's weight on the issue
*     score: float, candidate's score based on the user's survey input; the higher the score, the more
*       compatible the candidate is to the user
* 
* Usage examples:
* Through the API console (or REST API):
* 1) Go to Parse.com -> Core > API Console
* 2) Endpoint: POST functions/get_survey_candidates
* 3) Request body: {"user": "pcEbh8GpHi"}
*
* Example output:
* {
    "result": [
        {
            "candidate": "HDqZciBULT",
            "issues": [
                {
                    "compatibility": "Compatible",
                    "issue": "mQVtMXHSsY",
                    "position": "Strongly Agrees",
                    "weight": 2.681591987609863
                },
                {
                    "compatibility": "Compatible",
                    "issue": "ink8H9BiGe",
                    "position": "Strongly Disagrees",
                    "weight": 2
                },
                // More issues here
            ],
            "score": 40.10945272445679
        },
        // More candidates here
    ]
* }    
*/

var Compatibility = {
    STRONG_COMPATIBLE: 'Strongly compatible',
    COMPATIBLE: 'Compatible',
    INCOMPATIBLE: 'Incompatible',
    STRONG_INCOMPATIBLE: 'Strongly incompatible'
};

var SurveyCandidate = function(id, first, last) {
    this.id = id;
    this.first = first;
    this.last = last;
    this.score = 0;
    this.issues = []; // Holds processed issues with compatibility
    this.parseIssues = []; // Holds unprocessed arrays from Parse
};

var Issue = function(topic, candidatePosition, userScore, weight) {
    var result;
    switch (userScore) {
        case 1: // User selected "Strongly Disagree"
        switch (candidatePosition) {
            case "Strongly Agrees":
            case "Agrees":
            result = Compatibility.STRONG_INCOMPATIBLE;
            break;
            case "Neutral/No opinion":
            result = Compatibility.INCOMPATIBLE;
            break;
            case "Disagrees":
            result = Compatibility.COMPATIBLE;
            break;
            case "Strongly Disagrees":
            result = Compatibility.STRONG_COMPATIBLE;
            break;
        }
        break;
        case 2: // User selected "Disagree"
        switch (candidatePosition) {
            case "Strongly Agrees":
            result = Compatibility.STRONG_INCOMPATIBLE;
            break;
            case "Agrees":
            result = Compatibility.INCOMPATIBLE;
            break;
            case "Neutral/No opinion":
            result = Compatibility.COMPATIBLE;
            break;
            case "Disagrees":
            result = Compatibility.STRONG_COMPATIBLE;
            break;
            case "Strongly Disagrees":
            result = Compatibility.COMPATIBLE;
            break;
        }
        break;
        case 3: // User selected "Neutral"
        result = Compatibility.COMPATIBLE;
        break;
        case 4: // User selected "Agree"
        switch (candidatePosition) {
            case "Strongly Agrees":
            result = Compatibility.COMPATIBLE;
            break;
            case "Agrees":
            result = Compatibility.STRONG_COMPATIBLE;
            break;
            case "Neutral/No opinion":
            result = Compatibility.COMPATIBLE;
            break;
            case "Disagrees":
            result = Compatibility.INCOMPATIBLE;
            break;
            case "Strongly Disagrees":
            result = Compatibility.STRONG_INCOMPATIBLE;
            break;
        }
        break;
        case 5: // User selected "Strongly Agree"
        switch (candidatePosition) {
            case "Strongly Agrees":
            result = Compatibility.STRONG_COMPATIBLE;
            break;
            case "Agrees":
            result = Compatibility.COMPATIBLE;
            break;
            case "Neutral/No opinion":
            result = Compatibility.INCOMPATIBLE;
            break;
            case "Disagrees":
            case "Strongly Disagrees":
            result = Compatibility.STRONG_INCOMPATIBLE;
            break;
        }
        break;
        default: // Default to neutral
        result = Compatibility.COMPATIBLE;
        break;
    }
    this.topic = topic;
    this.position = candidatePosition;
    this.compatibility = result;
    this.weight = weight;
};

var compareIssue = function(a, b) {
    if (a.compatibility == b.compatibility)
        return (a.weight > b.weight) ? -1 : 1;
    switch (a.compatibility) {
        case Compatibility.STRONG_COMPATIBLE:
        return -1;
        case Compatibility.COMPATIBLE:
        if (b.compatibility == Compatibility.STRONG_COMPATIBLE)
            return 1;
        else
            return -1;
        break;
        case Compatibility.INCOMPATIBLE:
        if (b.compatibility == Compatibility.STRONG_INCOMPATIBLE)
            return -1;
        else
            return 1;
        break;
        case Compatibility.STRONG_INCOMPATIBLE:
        return 1;
        default:
        return 1;
    }
};


SurveyCandidate.prototype.addIssue = function(topic, candidatePos, userScore, weight) {
    this.issues.push(new Issue(topic, candidatePos, userScore, weight));
};

var compareCandidate = function(a, b) {
    if (a.score > b.score)
        return -1;
    else if (a.score == b.score)
        return 0;
    else
        return 1;
};

SurveyCandidate.prototype.scoreAndSort = function() {
    for (var i = 0; i < this.issues.length; i++) {
        var value = 1;
        switch (this.issues[i].compatibility) {
            case Compatibility.STRONG_COMPATIBLE:
            value = 2;
            break;
            case Compatibility.COMPATIBLE:
            value = 1;
            break;
            case Compatibility.INCOMPATIBLE:
            value = -1;
            break;
            case Compatibility.STRONG_INCOMPATIBLE:
            value = -2;
            break;
        }
        this.score += value * this.issues[i].weight;
    }
    this.issues.sort(compareIssue);
};

// The main Cloud Code function that gets called
Parse.Cloud.define("get_survey_candidates", function(request, response) {
    // Given userId, retrieve the user object
    var query = new Parse.Query(Parse.User);
    query.equalTo("objectId", request.params.user);  
    query.find({
        success: function(results) {
            var surveyAnswers = results[0].get("surveyAnswers");
            var surveyWeights = results[0].get("surveyAnswerWeights");

            // Retrieve all the candidates
            var Candidate = Parse.Object.extend("Candidate");
            var query = new Parse.Query(Candidate);

            // Create anonymous function to pass the user survery answers and weights to asynchronous function 
            (function(surveyAnswers, surveyWeights){
                query.find({
                    success: function(results) {
                        // Create an array of SurveyCandidate objects 
                        var candidates = [];
                        alert("Successfully retrieved " + results.length);
                        for (var i = 0; i < results.length; i++) {
                            var object = results[i];
                            var currentCandidate = new SurveyCandidate(object.id, object.get('firstName'), object.get('lastName'));
                            currentCandidate.parseIssues = object.get('Issues');
                            candidates.push(currentCandidate);
                        }
                        // Code to sort candidate list based on user survey results
                        // Assumes the following:
                        // 1. constructed candidate list with assigned parseIssues for each candidate
                        // 2. two lists of information for survey, one containing answers and the other weights
                        // The above items are modeled after structure of stored data in Parse
                        for (var i = 0; i < candidates.length; i++) {
                            for (var j = 0; j < candidates[i].parseIssues.length; j++) {
                                // Get the candidate's position on the issue
                                var curIssue = candidates[i].parseIssues[j];
                                var issueId = Object.keys(curIssue)[0];
                                var candidatePositionOnIssue = curIssue[issueId];

                                // Get the user's position and weight on the issue
                                var userPositionOnIssue = surveyAnswers[issueId];
                                var userWeightForIssue = surveyWeights[issueId];

                                candidates[i].addIssue(issueId, candidatePositionOnIssue, userPositionOnIssue, userWeightForIssue);
                            }
                            candidates[i].scoreAndSort();
                        }
                        candidates.sort(compareCandidate);

                        var allCandidates = []
                        
                        // Create the JSON 
                        for (var i = 0; i < candidates.length; i++) {
                            var sortedIssues = [];
                            for (var k = 0; k < candidates[i].issues.length; k++) {
                                var candidateIssue = {
                                    "issue": candidates[i].issues[k].topic,
                                    "position": candidates[i].issues[k].position,
                                    "compatibility": candidates[i].issues[k].compatibility,
                                    "weight": candidates[i].issues[k].weight
                                }
                                sortedIssues.push(candidateIssue);
                            }
                            var candidateScoreAndSortedIssues = {
                                "candidate": candidates[i].id,
                                "score": candidates[i].score,
                                "issues": sortedIssues
                            }
                            allCandidates.push(candidateScoreAndSortedIssues);
                        }

                        // JSON of candidate elements
                        response.success(allCandidates);
                    },
                    error: function(error) {
                        alert("Error: " + error.code + " " + error.message);
                        response.error("Error: " + error.code + " " + error.message);
                    }
                });
            })(surveyAnswers, surveyWeights);                
        },
        error: function(error) {
            alert("Error: " + error.code + " " + error.message);
            response.error("Error: " + error.code + " " + error.message);
        }
    });    
});



