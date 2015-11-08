var SurveyCandidate = function(first, last) {
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

var Compatibility = {
    STRONG_COMPATIBLE: 'Strongly compatible',
    COMPATIBLE: 'Compatible',
    INCOMPATIBLE: 'Incompatible',
    STRONG_INCOMPATIBLE: 'Strongly incompatible'
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

SurveyCandidate.prototype.print = function() {
    console.log(this.first, this.last);
    console.log(" score:", this.score);
    for (var i = 0; i < this.issues.length; i++) {
        console.log(" issue: ", this.issues[i].topic, this.issues[i].position, this.issues[i].compatibility, this.issues[i].weight);
    }
};

var surveyAnswers = [["0KKzJI5OKd",3],["2Mx1U4lgFL",5],["2tgFQpsKNI",3],["3baRHWfqeN",4],["ArTSPfrntt",3],["DQTeEEiDiS",3],["WnpxgeQXEI",3],["Y0zpuDGVaa",3],["YKWOsXT9JM",3],["YzC3sbpKGC",3],["ZGZERVsKIa",3],["ftUbQQVX45",3],["h8SQW3Go6W",1],["ink8H9BiGe",5],["jZHJjGVr8K",3],["k96Jk9nWXf",3],["mQVtMXHSsY",5],["oG0xwWLXct",3],["pAlc2vaLmF",3],["yZOwc3wJ24",3]];
var surveyWeights = [["0KKzJI5OKd",2],["2Mx1U4lgFL",2],["2tgFQpsKNI",2],["3baRHWfqeN",1.427860736846924],["ArTSPfrntt",2],["DQTeEEiDiS",2],["WnpxgeQXEI",2],["Y0zpuDGVaa",2],["YKWOsXT9JM",2],["YzC3sbpKGC",2],["ZGZERVsKIa",2],["ftUbQQVX45",2],["h8SQW3Go6W",2],["ink8H9BiGe",2],["jZHJjGVr8K",2],["k96Jk9nWXf",2],["mQVtMXHSsY",2.681591987609863],["oG0xwWLXct",2],["pAlc2vaLmF",2],["yZOwc3wJ24",2]];
var hillary = new SurveyCandidate("Hillary", "Clinton");
var bernie = new SurveyCandidate("Bernie", "Sanders");
var jeb = new SurveyCandidate("Jeb", "Bush");
hillary.parseIssues = [["pAlc2vaLmF","Strongly Agrees"],["ftUbQQVX45","Strongly Agrees"],["DQTeEEiDiS","Strongly Agrees"],["ArTSPfrntt","Disagrees"],["2Mx1U4lgFL","Strongly Disagrees"],["oG0xwWLXct","Strongly Agrees"],["2tgFQpsKNI","Disagrees"],["3baRHWfqeN","Strongly Disagrees"],["0KKzJI5OKd","Strongly Agrees"],["k96Jk9nWXf","Strongly Disagrees"],["ink8H9BiGe","Strongly Agrees"],["YKWOsXT9JM","Disagrees"],["YzC3sbpKGC","Strongly Agrees"],["yZOwc3wJ24","Strongly Agrees"],["jZHJjGVr8K","Agrees"],["ZGZERVsKIa","Strongly Disagrees"],["Y0zpuDGVaa","Agrees"],["mQVtMXHSsY","Disagrees"],["WnpxgeQXEI","Disagrees"],["h8SQW3Go6W","Disagrees"]];
bernie.parseIssues = [["pAlc2vaLmF","Strongly Agrees"],["ftUbQQVX45","Strongly Agrees"],["DQTeEEiDiS","Strongly Agrees"],["ArTSPfrntt","Strongly Disagrees"],["2Mx1U4lgFL","Strongly Disagrees"],["oG0xwWLXct","Strongly Agrees"],["2tgFQpsKNI","Strongly Disagrees"],["3baRHWfqeN","Neutral/No opinion"],["0KKzJI5OKd","Strongly Agrees"],["k96Jk9nWXf","Strongly Disagrees"],["ink8H9BiGe","Strongly Agrees"],["YKWOsXT9JM","Strongly Disagrees"],["YzC3sbpKGC","Strongly Agrees"],["yZOwc3wJ24","Strongly Agrees"],["jZHJjGVr8K","Agrees"],["ZGZERVsKIa","Strongly Disagrees"],["Y0zpuDGVaa","Strongly Disagrees"],["mQVtMXHSsY","Disagrees"],["WnpxgeQXEI","Strongly Disagrees"],["h8SQW3Go6W","Strongly Agrees"]];
jeb.parseIssues = [["pAlc2vaLmF","Strongly Disagrees"],["ftUbQQVX45","Disagrees"],["DQTeEEiDiS","Disagrees"],["ArTSPfrntt","Strongly Agrees"],["2Mx1U4lgFL","Strongly Disagrees"],["oG0xwWLXct","Strongly Disagrees"],["2tgFQpsKNI","Strongly Agrees"],["3baRHWfqeN","Agrees"],["0KKzJI5OKd","Disagrees"],["k96Jk9nWXf","Strongly Agrees"],["ink8H9BiGe","Disagrees"],["YKWOsXT9JM","Strongly Agrees"],["YzC3sbpKGC","Disagrees"],["yZOwc3wJ24","Strongly Disagrees"],["jZHJjGVr8K","Agrees"],["ZGZERVsKIa","Neutral/No opinion"],["Y0zpuDGVaa","Agrees"],["mQVtMXHSsY","Strongly Agrees"],["WnpxgeQXEI","Disagrees"],["h8SQW3Go6W","Strongly Disagrees"]];
var candidates = [hillary, bernie, jeb];

// Code to sort candidate list based on user survey results
// Assumes the following:
// 1. constructed candidate list with assigned parseIssues for each candidate
// 2. two lists of information for survey, one containing answers and the other weights
// The above items are modeled after structure of stored data in Parse
for (var i = 0; i < candidates.length; i++) {
    for (var j = 0; j < candidates[i].parseIssues.length; j++) {
        var curIssue = candidates[i].parseIssues[j];
        var k;
        for (k = 0; k < surveyAnswers.length; k++) {
            if (curIssue[0] == surveyAnswers[k][0])
                break;
        }
        candidates[i].addIssue(curIssue[0], curIssue[1], surveyAnswers[k][1], surveyWeights[k][1]);
    }
    candidates[i].scoreAndSort();
}
candidates.sort(compareCandidate);

for (var i = 0; i < candidates.length; i++) {
    candidates[i].print();
}
