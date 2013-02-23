package ai;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;

public class UrlContentsLoader
{    
    public static String load(String urlString) throws MalformedURLException, IOException
    {
        URL url = new URL(urlString);
        StringBuilder result;
        try (BufferedReader in = new BufferedReader(
             new InputStreamReader(url.openStream())))
        {
            result = new StringBuilder();
            String inputLine;
            while ((inputLine = in.readLine()) != null)
                result.append(inputLine);
        }
        return result.toString();
    }
}
