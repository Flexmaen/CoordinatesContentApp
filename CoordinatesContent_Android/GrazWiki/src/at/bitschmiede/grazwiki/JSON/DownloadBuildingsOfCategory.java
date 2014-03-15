package at.bitschmiede.grazwiki.JSON;

import java.io.IOException;
import java.util.Enumeration;
import java.util.Vector;

import org.json.JSONException;

import android.os.AsyncTask;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;

public class DownloadBuildingsOfCategory extends AsyncTask<String, Integer, Void> {

	protected Vector<DownloadEvents> _listeners;
	private Building[] _buildingList = null;

	@Override
	protected Void doInBackground(String... params) {
		RestService myRestService = new RestService();

		String category = params[0];
		_buildingList = null;
		try {
				_buildingList = myRestService.getAllBuildingsOfCategory(category);
		} catch (JsonParseException e) {
			e.printStackTrace();
		} catch (JsonMappingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (JSONException e) {
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
				eventHandler.downloadBuildingsOfCategoryCompleted(_buildingList);
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
