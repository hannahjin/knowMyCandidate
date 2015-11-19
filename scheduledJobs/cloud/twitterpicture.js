var _ = require('underscore');
var oauth = require("cloud/libs/oauth.js");
var Image = require("parse-image");

Parse.Cloud.job("update_twitter_pictures", function(request, status) {

        // Twitter users to process
    var screenNames = [
        "MartinOMalley",
        "HillaryClinton",
        "realDonaldTrump",
        "BernieSanders",
        "RealBenCarson",
        "marcorubio",
        "tedcruz",
        "JebBush",
        "CarlyFiorina",
        "GovMikeHuckabee",
        "RandPaul",
        "ChrisChristie",
        "JohnKasich",
        "LindseyGrahamSC",
        "GovernorPataki",
        "RickSantorum",
        "BobbyJindal",
        "gov_gilmore",
        "DrJillStein"
    ];

    var promise = Parse.Promise.as();

    _.each(screenNames, function(screenName){
        promise = promise.then(function(){
            return getTwitterImage(screenName);
        });
    });

    Parse.Promise.when(promise).then(function(){
        status.success("Twitter profile pictures saved");
    }, function(error){
        status.error("Twitter profile pictures failed to update");
    });

});

Parse.Cloud.define("generate_twitter_table");

function getTwitterImage(screenName){

    var promise = new Parse.Promise();
    var Candidate = Parse.Object.extend("Candidate");
    var query = new Parse.Query(Candidate);

    query.equalTo("twitterid", screenName);

    query.find().then(function(candidates){

        // TODO: need to fail promise here?
        if(candidates.length == 0)
            console.error("no candidates found for screenName " + screenName);

        var urlLink = "https://api.twitter.com/1.1/users/show.json?screen_name=" + screenName;

        var consumerSecret = "2Ce8McvWA4VuLCEQoDzCnva4sX1CUNc9XCdkuFspWU0I8P7jcy";
        var tokenSecret = "iUt5JrtyQVmAfcN0OFZTvju6pfNbMukXE4PreROlKiIyM";
        var oauth_consumer_key = "OFrWj8f0Ha4FWWuaVoLtIned6";
        var oauth_token = "3932922012-m89kcgHGWSOj8lrmwYTC4OXtBbpW8HsvCkdGl1N";

        var nonce = oauth.nonce(32);
        var ts = Math.floor(new Date().getTime() / 1000);
        var timestamp = ts.toString();

        var accessor = {
            consumerSecret: consumerSecret,
            tokenSecret: tokenSecret
        };

        var params = {
            oauth_version: "1.0",
            oauth_consumer_key: oauth_consumer_key,
            oauth_token: oauth_token,
            oauth_timestamp: timestamp,
            oauth_nonce: nonce,
            oauth_signature_method: "HMAC-SHA1"
        };

        var message = {
            method: "GET",
            action: urlLink,
            parameters: params
        };

        oauth.SignatureMethod.sign(message, accessor);

        var normPar = oauth.SignatureMethod.normalizeParameters(message.parameters);
        var baseString = oauth.SignatureMethod.getBaseString(message);
        var sig = oauth.getParameter(message.parameters, "oauth_signature") + "=";
        var encodedSig = oauth.percentEncode(sig);

        Parse.Cloud.httpRequest({
            method: "GET",
            url: urlLink,
            headers: {
               Authorization: 'OAuth oauth_consumer_key="'+oauth_consumer_key+'", oauth_nonce=' + nonce + ', oauth_signature=' + encodedSig + ', oauth_signature_method="HMAC-SHA1", oauth_timestamp=' + timestamp + ',oauth_token="'+oauth_token+'", oauth_version="1.0"'
            }
        }).then(function(httpResponse) { 
            var data = JSON.parse(httpResponse.text);

            var image_url = data.profile_image_url;
            // get full resolution image
            image_url = image_url.replace("_normal", "");

            Parse.Cloud.httpRequest({
                url: image_url

            }).then(function(httpResponse) {
                var image = new Image();
                return image.setData(httpResponse.buffer);

            }, function(error) {
                // failed to download image
                console.log(error);
                promise.reject(error.message);

            }).then(function(image) {
                var size = Math.min(image.width(), image.height());
                return image.crop({
                    left: (image.width() - size) / 2,
                    top: (image.height() - size) / 2,
                    width: size,
                    height: size 
                });

            }).then(function(image) {
                return image.scale({
                    width: 200,
                    height: 200
                });

            }).then(function(image) {
                return image.setFormat("JPEG");

            }).then(function(image) {
                // get image data in a Buffer
                return image.data();

            }).then(function(buffer) {
                // save image into new file
                var base64 = buffer.toString("base64");
                var cropped = new Parse.File("thumbnail.jpg", { base64: base64 });
                return cropped.save();

            }).then(function(cropped){
                // attach image file to original candidate object
                candidates[0].set("thumbnail", cropped);
                candidates[0].save(null, {
                    success: function(candidate) {
                        // The object was saved successfully.
                        promise.resolve();
                    },
                    error: function(candidate, error) {
                        // The save failed.
                        console.log("Candidate twitter image save failed. Error: " + error.code + " " + error.message);
                        promise.reject(error.message);
                    }
                });
            });
        }, function(error) {
            // twitter api call failed
            console.log(error);
            promise.reject(error.message);
        });
    });

    return promise;
}
