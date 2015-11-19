var Image = require("parse-image");

// Bing Search API keys
API_KEY = "Cfd+0huY6d7Ekhz04lEXQfJBr2jt5AS3Oi323X8TtV4";
BASE_64_ENCODED_API_KEY = "OkNmZCswaHVZNmQ3RWtoejA0bEVYUWZKQnIyanQ1QVMzT2kzMjNYOFR0VjQ="
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
            // return Parse.Promise.error("Bing api returned no results for candidate: " + candidateID + " and title: " + title);
        
            // set default image if no results from bing
            console.error("Bing api returned no results. Using default image for candidate: " + candidateID + " and title: " + title);
            bing_thumbnail = "http://files.parsetfss.com/1d04d21c-5d62-4dc6-87ba-62701bc65478/tfss-19fe64ca-c9b8-4085-8605-3d81163d1d84-thumbnail.jpg";
        } else {
            // bing_thumbnail = json_result.d.results[0].Thumbnail.MediaUrl;
            bing_thumbnail = json_result.d.results[0].MediaUrl;
            if (bing_thumbnail.length < 5)
                bing_thumbnail = "http://files.parsetfss.com/1d04d21c-5d62-4dc6-87ba-62701bc65478/tfss-19fe64ca-c9b8-4085-8605-3d81163d1d84-thumbnail.jpg";                
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
            console.error("Bing thumbnail download failed. Using default image for candidate: " + candidateID + " and title: " + title);
            saveNewsfeed(newsFeed);

            // TODO: add default image

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
            /*newsFeed.save(null, {
              success: function(newsFeed) {
                // The object was saved successfully.
              },
              error: function(newsFeed, error) {
                // The save failed.
                alert("Newsfeed save failed. Error: " + error.code + " " + error.message);
              }
            });*/
        });
    }, function(error) {
        // bing_thumbnail URL fail
        console.error(error);
        // save newsFeed without thumbnail
        saveNewsfeed(newsFeed);
    });
}

// set twitter images and news items that are missing images
Parse.Cloud.beforeSave('Newsfeed', function(request, response) {
    var newsfeed = request.object;
    
    // handle news items
    if (newsfeed.get("source") != "Twitter") {
        if (newsfeed.get("thumbnail")) {
            // news item already has image, pass
            response.success();
        } else {
            // news item missing thumbnail
            console.log("identified missing thumbnail for Candidate: " + newsfeed.get("candidateID")) + " Title: " + newsfeed.get("title");
            
        }
    }

})
