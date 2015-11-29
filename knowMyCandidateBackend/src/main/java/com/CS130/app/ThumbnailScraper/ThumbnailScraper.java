package com.CS130.app.ThumbnailScraper;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.SocketTimeoutException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLConnection;

import javax.imageio.ImageIO;

import org.apache.commons.io.FileUtils;
import org.jsoup.HttpStatusException;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class ThumbnailScraper {

    public String thumbnail_scrape(String url) {
        
        try {
            Document doc = Jsoup.connect(url).userAgent("Mozilla").get();
            Elements images = doc.getElementsByTag("img");
            
            URL max_img_url = getMaxImage(images);
            
            if (max_img_url != null)
                return max_img_url.toString();
            else
                return null;
        } catch (IOException e) {
            System.err.println("Failed to retrieve URL: " + url + "\n    Exception: " + e.toString());
        }
        
        return null;
    }
    
    private URL getMaxImage(Elements images) {
        int max_area = 0;
        URL max_img_url = null;
        
        for (Element image : images) {
            try {
                URI img_uri;
                if(!image.attr("abs:src").equals("")) {
                	img_uri = new URI(image.attr("abs:src").replace(" ", "%20"));
                } else if (!image.attr("abs:data-baseurl").equals("")) {
                	// for LA Times website
                	img_uri = new URI(image.attr("abs:data-baseurl").replace(" ", "%20"));;
                } else {
                	continue;
                }
                
                URL img_url = img_uri.toURL();
                String img_path = img_url.getPath();
                File img_file;
                
                // get file extension
                int period_index = img_path.lastIndexOf('.');
                if (img_path.length() - period_index < 6 && period_index > 0)
                	img_file = new java.io.File("/tmp/picture" + img_path.substring(img_path.lastIndexOf('.')));
                else
                	img_file = new java.io.File("/tmp/picture");
                
                // FileUtils.copyURLToFile(img_url, img_file, 2000, 2000);
                HttpURLConnection conn = (HttpURLConnection) img_url.openConnection();
                HttpURLConnection.setFollowRedirects(true);
                conn.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Firefox/31.0");
                conn.setConnectTimeout(2000);
                conn.setReadTimeout(10000);
                conn.setRequestMethod("GET");
                conn.connect();
                FileUtils.copyInputStreamToFile(conn.getInputStream(), img_file);
                
                BufferedImage bimage = ImageIO.read(img_file);
                if (bimage != null) {

                    int width = bimage.getWidth();
                    int height = bimage.getHeight();
                    
                    int area = width * height;
                    if (area > max_area) {
                        max_area = area;
                        max_img_url = img_url;
                    }
                }
                
                img_file.delete();
            } catch (MalformedURLException e) {
                System.err.println("Failed to parse URL for: " + image.attr("abs:src") + " Exception: " + e);
            } catch (SocketTimeoutException e){
                System.err.println("SocketTimeOut, failed to check image size for url: " + image.attr("abs:src") + " Exception: " + e);
            } catch (IOException e) {
                System.err.println("IOException, failed to check image size for url: " + image.attr("abs:src") + " Exception: " + e);
            } catch (URISyntaxException e) {
                System.err.println("Failed to parse URI: " + image.attr("abs:src") + " Exception: " + e);
            } catch (IllegalArgumentException e) {
                System.err.println("Illegal argument exception for url: " + image.attr("abs:src") + " Exception: " + e);
            } catch (Exception e) {
                System.err.println("EXCEPTION CATCH ALL url: " + image.attr("abs:src") + " Exception: " + e);
            }
        }
        // if biggest image is small, probably only logos were found
        if (max_area < 30000)
            return null;
        return max_img_url;
    }
    
}
