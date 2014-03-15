package at.bitschmiede.grazwiki.JSON;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringReader;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.Charset;

import org.json.JSONException;
import org.json.JSONObject;

import android.util.JsonReader;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * 
 * @author thas
 *
 */
public class RestService {

    static InputStream is = null;
    static JSONObject jObj = null;
    static String json = "";
    static JsonReader reader = null;
	
	
	/**
	 * Searches for all Buildings
	 * @return Building[]: Array of Building Items
	 * @throws JsonParseException
	 * @throws JsonMappingException
	 * @throws IOException
	 * @throws JSONException
	 */
	public Building[] getAllBuildings() throws JsonParseException, JsonMappingException, IOException, JSONException
	{
		String jSonFile = this.readJsonFromUrl("http://www.server.url/communication/jsonService.php?action=getAllBuildings");
    	ObjectMapper mapper  = new ObjectMapper();
		Building[] myBuildings = mapper.readValue(jSonFile, Building[].class);	
		return myBuildings;
	}
	
	/**
	 * Searches for all Buildings from a String
	 * @param  jsonString: Json String with all Buildings
	 * @return Building[]: Array of Building Items
	 * @throws JsonParseException
	 * @throws JsonMappingException
	 * @throws IOException
	 * @throws JSONException
	 */
	public Building[] getAllBuildingsFromString(String jsonString) throws JsonParseException, JsonMappingException, IOException, JSONException
	{
		String jSonFile = this.readJsonFromString(jsonString);
    	ObjectMapper mapper  = new ObjectMapper();
		Building[] myBuildings = mapper.readValue(jSonFile, Building[].class);
		return myBuildings;
	}
	
	/**
	 * Searches for all Buildings of a category
	 * @param  category: 	Category we want do search
	 * @return Building[]: 	Array of Building Items
	 * @throws JsonParseException
	 * @throws JsonMappingException
	 * @throws IOException
	 * @throws JSONException
	 */
	public Building[] getAllBuildingsOfCategory(String category) throws IOException, JSONException
	{
		StringBuilder sb = new StringBuilder();
		sb.append("http://www.server.url/communication/jsonService.php?action=getBuildingsOfCategory&category=");
		sb.append(URLEncoder.encode(category,"UTF-8"));
		String jSonFile = this.readJsonFromUrl(sb.toString());
		ObjectMapper mapper  = new ObjectMapper();
		Building[] myBuildings = mapper.readValue(jSonFile, Building[].class);
		return myBuildings;
	}
	
	/**
	 * Searches for all Categories
	 * @return Category[]: 	Array of Category Items
	 * @throws JsonParseException
	 * @throws JsonMappingException
	 * @throws IOException
	 * @throws JSONException
	 */
	public Category[] getAllCategories() throws IOException, JSONException
	{
		
		String jSonFile = this.readJsonFromUrl("http://www.server.url/communication/jsonService.php?action=getAllCategories");
    	ObjectMapper mapper  = new ObjectMapper();
    	Category[] mycategories = mapper.readValue(jSonFile, Category[].class);
		return mycategories;
	}
	
	/**
	 * Searches for Buildings in a Region of mapQuest
	 * @param minLatitude
	 * @param maxLatitude
	 * @param minLongitude
	 * @param maxLongitude
	 * @return Building[]: 	Array of Building Items
	 * @throws JsonParseException
	 * @throws JsonMappingException
	 * @throws IOException
	 */
	public Building[] getBuildingsOfRegion(double minLatitude,double maxLatitude, double minLongitude, double maxLongitude) throws JsonParseException, JsonMappingException, IOException
	{
		StringBuilder sb = new StringBuilder();
		sb.append("http://www.server.url/communication/jsonService.php?action=getBuildingsOfRegion");
		sb.append("&min_lat=");
		sb.append(minLatitude);
		sb.append("&max_lat=");
		sb.append(maxLatitude);
		sb.append("&min_long=");
		sb.append(minLongitude);
		sb.append("&max_long=");
		sb.append(maxLongitude);
	   	String jSonFile;
		try {
			jSonFile = this.readJsonFromUrl(sb.toString());
			ObjectMapper mapper  = new ObjectMapper();
			Building[] myBuildings = mapper.readValue(jSonFile, Building[].class);
			return myBuildings;
		
		} catch (IOException e) {
			e.printStackTrace();
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return null;
	}
	

	/**
	 * Searches for the Information of a Building
	 * @param buildingID
	 * @return BuildingDescription[]: Array of Building Description Items 
	 * @throws JsonMappingException
	 * @throws IOException
	 * @throws JSONException
	 */
	public BuildingDescription[] getBuildingInformation(int buildingID) throws JsonMappingException, IOException, JSONException
	{
	   	StringBuilder sb = new StringBuilder();
		sb.append("http://www.server.url/communication/jsonService.php?action=getBuildingInformation&bid=");
		sb.append(buildingID);
		String jSonFile = this.readJsonFromUrl(sb.toString());
    	ObjectMapper mapper  = new ObjectMapper();
    	BuildingDescription[] myBuildings = mapper.readValue(jSonFile, BuildingDescription[].class);
		return myBuildings;
	}
	
	/**
	 * Searches for all Routes
	 * @return Route[]: Array of Route Items
	 * @throws JsonParseException
	 * @throws JsonMappingException
	 * @throws IOException
	 * @throws JSONException
	 */
	public Route[] getAllRoutes() throws JsonMappingException, IOException, JSONException
	{
		String jSonFile = this.readJsonFromUrl("http://www.server.url/communication/jsonService.php?action=getAllRoutes");
    	ObjectMapper mapper  = new ObjectMapper();
		Route[] myRouteArray = mapper.readValue(jSonFile, Route[].class);
		return myRouteArray;
	}
	
	/**
	 * Searches for the Information of a Route
	 * @param routeID
	 * @return
	 * @throws JsonMappingException
	 * @throws IOException
	 * @throws JSONException
	 */
	public RouteInformation getRouteInformation(int routeID) throws JsonMappingException, IOException, JSONException
	{
		StringBuilder sb = new StringBuilder();
		sb.append("http://www.server.url/communication/jsonService.php?action=getRouteInformation&rid=");
		sb.append(routeID);
		String jSonFile = this.readJsonFromUrl(sb.toString());
    	ObjectMapper mapper  = new ObjectMapper();
    	RouteInformation myRoutes = mapper.readValue(jSonFile, RouteInformation.class);
		return myRoutes;
	}
	
	
	//-------------------------------
	//-- Private Helper Functions  --
	//-------------------------------
	
	
	private  String readAll(Reader rd) throws IOException {
	    StringBuilder sb = new StringBuilder();
	    int cp;
	    while ((cp = rd.read()) != -1) {
	      sb.append((char) cp);
	    }
	    return sb.toString();
	  }
	
	
	public  String readJsonFromUrl(String url) throws IOException, JSONException {
	    InputStream is = new URL(url).openStream();
	    try {
	      BufferedReader rd = new BufferedReader(new InputStreamReader(is, Charset.forName("UTF-8")));
	      String jsonText = this.readAll(rd);
	      return jsonText;
	    
	    } finally {
	      is.close();
	    }
	  }
	
	public  String readJsonFromString(String jsonString) throws IOException, JSONException {
	    try {
	    	BufferedReader br = new BufferedReader(new StringReader(jsonString));
	    	String jsonText = this.readAll(br);
	    	return jsonText;
	    
	    } finally {
	    	
	    }
	  }
}
