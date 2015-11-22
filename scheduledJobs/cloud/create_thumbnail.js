var Image = require("parse-image");
var url = require('url');

// Bing Search API keys
API_KEY = "O8ROly8zYwdZ9aPwePFsLqOXjEeeCMuqYKGWV15TaTo";
BASE_64_ENCODED_API_KEY = "Ok84Uk9seTh6WXdkWjlhUHdlUEZzTHFPWGpFZWVDTXVxWUtHV1YxNVRhVG8="
AUTH = "Basic " + BASE_64_ENCODED_API_KEY;

function saveNewsfeed(newsFeed) {
    newsFeed.save(null, {
      success: function(newsFeed) {
        // The object was saved successfully.
      },
      error: function(newsFeed, error) {
        // The save failed.
        alert("Newsfeed save failed. Error: " + error.code + " " + error.message);
      }
    });
}

module.exports.setThumbnailandSaveNewsfeed = function(newsFeed, title, candidateID) {
    var formatted_title = title.replace(/['"’‘]+/g, '');
    formatted_title = encodeURIComponent(formatted_title);
    var formatted_url = 'https://api.datamarket.azure.com/Bing/Search/v1/Image?Query=%27'+ formatted_title +'%27&$top=1&$format=json';

    Parse.Cloud.httpRequest({
        url: formatted_url,
            headers: {
            'Authorization': AUTH,
        }
    }).then(function(httpResponse) {
        // bing api request success
        var json_result = JSON.parse(httpResponse.text);
        // TODO: find cleaner way fo checking valid JSON
        var bing_thumbnail;
        if (httpResponse.text.length < 40 || !json_result) {
            // bing_thumbnail URL fail, error is caught below
            return Parse.Promise.error("Bing api returned no results. Using default image for candidate: " + candidateID + " and title: " + title);

        } else {
            bing_thumbnail = json_result.d.results[0].MediaUrl;

            // if invalid url
            if (bing_thumbnail.length < 5) {
                return Parse.Promise.error("Bing api returned invalid url. Using default image for candidate: " + candidateID + " and title: " + title);
            }
        }
        return bing_thumbnail;        
    }, function(httpResponse) {
        // bing api request error
        console.error("bing_thumbnail httprequest failed with response code " + httpResponse.status);
    }).then(function(bing_thumbnail) {
        // bing_thumbnail URL success
        Parse.Cloud.httpRequest({
            url: bing_thumbnail
        }).then(function(response) {
            // bing thumbnail download success
            var image = new Image();
            return image.setData(response.buffer);
        
        }, function(error) {
            // bing thumbnail download fail
            // save newsFeed without thumbnail
            Parse.Promise.error("Bing thumbnail download failed. Saving with default thumbnail." + candidateID + " and title: " + title);

        }).then(function(image) {
            // Crop image to small of width or height
            var size = Math.min(image.width(), image.height());
            return image.crop({
                left: (image.width() - size) / 2,
                top: (image.height() - size) / 2,
                width: size,
                height: size
            });
        
        }).then(function(image) {
            // Resize image to 200x200
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
            // attach image file to original object
            newsFeed.set("thumbnail", cropped);
            saveNewsfeed(newsFeed);

        });
    }, function(error) {
        // Catch ALL Parse.Promse.error here
        // bing_thumbnail URL fail is highest level error caught here
        
        console.error(error);

        // save newsFeed with default thumbanil
        saveWithDefaultThumbnail(newsFeed);
    });
}

function saveWithDefaultThumbnail(newsfeed) {
    var Candidate = Parse.Object.extend("Candidate");
    var query = new Parse.Query(Candidate);
    query.equalTo("candidateID", newsfeed.get("candidateID"));
    query.first({
        success: function(candidate) {
            var thumbnail = candidate.get("thumbnail");
            newsfeed.set("thumbnail", thumbnail);
            newsfeed.save(null, {
              success: function(newsFeed) {
              },
              error: function(newsFeed, error) {
                // The save failed.
                alert("Newsfeed save failed. Error: " + error.code + " " + error.message);
              }
            });
        },
        error: function(error) {
            alert("Failed to get candidate from candiateID: " + error.code + " " + error.message);
            // save without thumbnail
            saveNewsfeed(newsFeed);
        }
    });
}

Parse.Cloud.define("testapi", function(request, response) {
    Parse.Cloud.run('getMaxImage', { image_url: 'testing.com' }, {
        success: function(max_image) {
            response.success(max_image);
        },
        error: function(error) {
            response.error(error);
        }
    });
});

Parse.Cloud.define("set_candidateid", function(request, response) {
    var Candidate = Parse.Object.extend("Candidate");
    var query = new Parse.Query(Candidate);

    query.find({
        success: function(results) {
            for (var i = 0; i < results.length; i++) {
                var candidate = results[i];
                var candidateFirstAndLast = candidate.get('firstName') + candidate.get('lastName');
                candidate.set("candidateID", candidateFirstAndLast);
                candidate.save(null, {
                    success: function(candidate) {
                        // The object was saved successfully.
                    },
                    error: function(candidate, error) {
                        // The save failed.
                        alert("candidatids save failed. Error: " + error.code + " " + error.message);
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
