package at.bitschmiede.grazwiki.JSON;

public class Building {
	
	private int _id;
	private String _title;
	private double _latitude;
	private double _longitude;
	
	public int getID(){return _id;}
	public String getTitle(){return _title;}
	public double getLatitude(){return _latitude;}
	public double getLongitude(){return _longitude;}
	
	public void setID(int val){_id = val;}
	public void setTitle(String val){_title = val;}
	public void setLatitude(double val){_latitude = val;}
	public void setLongitude(double val){_longitude = val;}
	

}
