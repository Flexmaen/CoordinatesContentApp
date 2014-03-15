package at.bitschmiede.grazwiki.JSON;

import java.io.IOException;
import java.util.Enumeration;
import java.util.Vector;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;

import android.os.AsyncTask;

public class DownloadBuildingsOfRegion extends AsyncTask<Double, Integer, Void> {

	protected Vector<DownloadEvents> _listeners;
	private Building[] _buildingList = null;

	@Override
	protected Void doInBackground(Double... params) {
		RestService myRestService = new RestService();

		_buildingList = null;

		double latitudeMin = params[0];
		double latitudeMax = params[1];
		double longitudeMin = params[2];
		double longituteMax = params[3];

		try {
			_buildingList =  myRestService.getBuildingsOfRegion(latitudeMin,latitudeMax,longitudeMin,longituteMax);
		} catch (JsonParseException e) {
			e.printStackTrace();
		} catch (JsonMappingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	protected void onProgressUpdate() {
		//called when the background task makes any progress
	}

	protected void onPreExecute() {
		//called before doInBackground() is started
		super.onPreExecute();
	}
	
	
	protected void onPostExecute(Void result) {
		//called after doInBackground() has finished 
		super.onPostExecute(result);
		if (_listeners != null && !_listeners.isEmpty())
		{
			Enumeration<DownloadEvents> e = _listeners.elements();
			while (e.hasMoreElements())
			{
				DownloadEvents eventHandler = (DownloadEvents)e.nextElement(); 
				eventHandler.downloadBuildingsOfRegionCompleted(_buildingList);
			}
		}
	}
	
	public void addListener(DownloadEvents listener)
	{
		if (_listeners == null)
			_listeners = new Vector<DownloadEvents>();

		_listeners.addElement(listener);
	}

}
