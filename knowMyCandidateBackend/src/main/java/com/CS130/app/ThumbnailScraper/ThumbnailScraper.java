package com.CS130.app.ThumbnailScraper;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;

import javax.imageio.ImageIO;

import org.apache.commons.io.FileUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class ThumbnailScraper {

    public String thumbnail_scrape(String url) {
        
        try {
            Document doc = Jsoup.connect(url).get();
            Elements images = doc.getElementsByTag("img");
            
            URL max_img_url = getMaxImage(images);
            
            if (max_img_url != null)
                return max_img_url.toString();
            else
                return null;
        } catch (IOException e) {
            System.err.println("Failed to retrieve URL");
            e.printStackTrace();
        }
        
        return null;
    }
    
    private URL getMaxImage(Elements images) {
        int max_area = 0;
        URL max_img_url = null;
        
        for (Element image : images) {
            try {
                URI img_uri = new URI(image.attr("abs:src").replace(" ", "%20"));
                URL img_url = img_uri.toURL();
                // create file with same filename
                String img_path = img_url.getPath();
                File img_file = new java.io.File(img_path.substring(img_path.lastIndexOf('/') + 1));
                FileUtils.copyURLToFile(img_url, img_file, 2000, 2000);
                
                BufferedImage bimage = ImageIO.read(img_file);
                
                int width = bimage.getWidth();
                int height = bimage.getHeight();
                
                int area = width * height;
                if (area > max_area) {
                    max_area = area;
                    max_img_url = img_url;
                }
                
                img_file.delete();
            } catch (MalformedURLException e) {
                System.err.println("Failed to parse URL for: " + image.attr("abs:src"));
            } catch (IOException e) {
                System.err.println("IOException, failed to check image size");
                e.printStackTrace();
            } catch (URISyntaxException e) {
                System.err.println("Failed to parse URI: " + image.attr("abs:src"));
            }
        }
        // if biggest image is small, probably only logos were found
        if (max_area < 400)
            return null;
        return max_img_url;
    }
    
    
    
}
