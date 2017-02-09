package com.kdev.app.parse.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import com.kdev.app.parse.domain.Article;

/**
 * @author K
 * @since 2017-01-14. 11:00
 * @description JSP 활성화
 */
@Controller
@RequestMapping(value="/parse")
public class SearchController {
	private static final Logger logger = LoggerFactory.getLogger(SearchController.class);
	
	// Daum API 활용하기 위한 REST 서비스
	private RestTemplate restTemplate;
	
	@RequestMapping(value="/search/okky", method=RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> searchOkky(@RequestParam(value="keyword") String keyword, @RequestParam(value="maxpage", defaultValue="2") int maxpage) throws Exception{
		keyword = URLEncoder.encode(keyword, "UTF-8");
		int count = 1;
		
		CloseableHttpClient httpClient = HttpClients.createDefault();
		HttpGet httpGet;
		
		String URL = "http://okky.kr/articles/questions?query="
				+keyword+"&sort=voteCount&order=desc";
		
		List<Article> list = new ArrayList<Article>();
		while(true){
			
		httpGet = new HttpGet(URL);
		Document doc;
		
		ResponseHandler<String> responseHandler = new ResponseHandler<String>() {
            public String handleResponse(final HttpResponse response) throws ClientProtocolException, IOException {
                int status = response.getStatusLine().getStatusCode();
                if (status >= 200 && status < 300) {
                    HttpEntity entity = response.getEntity();
                    return entity != null ? EntityUtils.toString(entity, "UTF-8") : null;
                } else {
                    throw new ClientProtocolException("Unexpected response status: " + status);
                }
            }
        };
		
		doc = Jsoup.parse(httpClient.execute(httpGet, responseHandler));
		Elements nodes = doc.select(".list-group-item h5");
		
		nodes.parallelStream().forEach(e -> {

			Article article = new Article();
			article.setTitle(e.text());
			article.setHref("http://okky.kr" + e.getElementsByTag("a").attr("href"));
			
			list.add(article);
		});
		
		Elements pages = doc.select(".pagination li");
		Element next = pages.last();
		
		boolean isNext = false;
		
		if(next != null)
			isNext = next.classNames().contains("next");
		
		if(!isNext || count >= maxpage)
			break;
		
		URL = "http://okky.kr" + next.getElementsByTag("a").attr("href");
		count++;
		}
		
		return new ResponseEntity<Object>(list, HttpStatus.ACCEPTED);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/search/stackoverflow", method=RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> searchStackOverflow(@RequestParam(value="keyword") String keyword, @RequestParam(value="maxpage", defaultValue="5") int maxpage) throws Exception {
		int count = 1;

		keyword = URLEncoder.encode(keyword, "UTF-8");

		CloseableHttpClient httpClient = HttpClients.createDefault();
		HttpGet httpGet;
		
		List<Article> list = new ArrayList<Article>();
		
		while(true){
			String URL = "https://api.stackexchange.com/2.2/search?order=asc&sort=votes&site=stackoverflow&pagesize=10&page="+count+"&intitle="+keyword;
			httpGet = new HttpGet(URL);
			
			ResponseHandler<String> responseHandler = new ResponseHandler<String>() {
	            public String handleResponse(final HttpResponse response) throws ClientProtocolException, IOException {
	                int status = response.getStatusLine().getStatusCode();
	                if (status >= 200 && status < 300) {
	                    HttpEntity entity = response.getEntity();
	                    return entity != null ? EntityUtils.toString(entity, "UTF-8") : null;
	                } else {
	                    throw new ClientProtocolException("Unexpected response status: " + status);
	                }
	            }
	        };
			
        
        String responseEntity = httpClient.execute(httpGet, responseHandler);
        
        JSONParser jsp = new JSONParser();
		JSONObject response = (JSONObject)jsp.parse(responseEntity);
		JSONArray items = (JSONArray)response.get("items");
		
		items.parallelStream().forEach(e->{
			JSONObject json = (JSONObject)e;
			
			Article article = new Article();
			article.setTitle((String)json.get("title"));
			article.setHref((String)json.get("link"));
			
			list.add(article);
		});
		
		if(count >= maxpage)
			break;
		
		count++;
		}
		
		
		return new ResponseEntity<Object>(list, HttpStatus.ACCEPTED);
	}
	
	@SuppressWarnings("unchecked")
@RequestMapping(value="/search/daum", method=RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> searchDaum(@RequestParam(value="keyword") String keyword) throws Exception {
		int count = 1;
		List<Article> list = new ArrayList<Article>();
		
		while(true){
		//Daum Search API
		restTemplate = new RestTemplate();
		String responseString = restTemplate.getForObject("https://apis.daum.net/search/blog?apikey=e2d8fe53fd161e9774a4417691c6d54d&pageno="+count+"&output=json&q="+keyword, String.class);
		
		JSONParser jsp = new JSONParser();
		JSONObject response = (JSONObject)jsp.parse(responseString);
		JSONObject channel = (JSONObject)response.get("channel");
		
		JSONArray item = (JSONArray)channel.get("item");
		
		item.parallelStream().forEach(e->{
			JSONObject json = (JSONObject)e;
			
			Article article = new Article();
			article.setTitle((String)json.get("title"));
			article.setHref((String)json.get("link"));
			
			list.add(article);
		});
		
		if(count == 3)
			break;
			count++;
		}
		return new ResponseEntity<Object>(list, HttpStatus.ACCEPTED);
	}
}