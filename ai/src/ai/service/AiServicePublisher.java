package ai.service;

import javax.xml.ws.Endpoint;
import java.util.logging.Logger;

public class AiServicePublisher
{
    private static final Logger log = Logger.getLogger(AiServicePublisher.class.getName());

    public static void main(String[] args)
    {
		String url = "http://0.0.0.0:5600/ai";
		log.info("Lords AI service started on url "+url);
        Endpoint.publish(url, new AiServiceImpl());
    }
}
