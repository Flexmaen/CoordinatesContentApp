package at.bitschmiede.grazwiki;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.Menu;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListView;
import at.bitschmiede.grazwiki.JSON.Building;
import at.bitschmiede.grazwiki.JSON.BuildingDescription;
import at.bitschmiede.grazwiki.JSON.Category;
import at.bitschmiede.grazwiki.JSON.DownloadEvents;
import at.bitschmiede.grazwiki.JSON.Route;
import at.bitschmiede.grazwiki.JSON.RouteInformation;

public class SearchBuildings extends Activity implements DownloadEvents,
		OnItemClickListener {

	// Building Array
	private Building[] _buildings;
	// building names
	private String[] _buildingNames;

	public String[] getBuldingNames() {
		return _buildingNames;
	}

	public void setBuildingNames(String[] val) {
		_buildingNames = val;
	}

	// List view
	private ListView lv;

	// Listview Adapter
	ArrayAdapter<String> adapter;
	// TESTCHECKIN

	// Search EditText
	EditText inputSearch;

	// ArrayList for Listview
	ArrayList<HashMap<String, String>> productList;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_search_buildings);

		// set title of menu bar
		setTitle("Suche nach Adressen");

		// --Dummy Code zum Downloaden Aller Buildings. EVENT: ->
		// downloadAllBuildingsCompleted()

		GlobalState gs = (GlobalState) getApplication();
		_buildings = gs.getAllBuildings();

		List<String> list = new ArrayList<String>();
		for (int i = 0; i < _buildings.length; i++) {
			list.add(_buildings[i].getTitle());
		}

		lv = (ListView) findViewById(R.id.list_view);
		inputSearch = (EditText) findViewById(R.id.inputSearch);

		// Adding items to listview
		adapter = new ArrayAdapter<String>(this, R.layout.list_item,
				R.id.product_name, list);
		lv.setAdapter(adapter);
		lv.setOnItemClickListener(this);

		/**
		 * Enabling Search Filter
		 * */
		inputSearch.addTextChangedListener(new TextWatcher() {

			@Override
			public void onTextChanged(CharSequence cs, int arg1, int arg2,
					int arg3) {
				// When user changed the Text
				SearchBuildings.this.adapter.getFilter().filter(cs);
			}

			@Override
			public void beforeTextChanged(CharSequence arg0, int arg1,
					int arg2, int arg3) {

			}

			@Override
			public void afterTextChanged(Editable arg0) {
			}
		});
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		/*
		 * Intent returnIntent = new Intent();
		 * returnIntent.putExtra("buildingsid","-2106444294");
		 * setResult(RESULT_OK,returnIntent); finish();
		 */

		// finish();
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.search_buildings, menu);
		return true;
	}

	public boolean updateListViewAndSetAdapter() {
		// Adding items to listview
		adapter = new ArrayAdapter<String>(this, R.layout.list_item,
				R.id.product_name, _buildingNames);
		lv.setAdapter(adapter);
		return true;
	}

	@Override
	public void downloadBuildingsOfRegionCompleted(
			at.bitschmiede.grazwiki.JSON.Building[] buildingsInRegion) {
	}

	@Override
	public void downloadAllBuildingsCompleted(
			at.bitschmiede.grazwiki.JSON.Building[] buildingsInRegion) {
	}

	@Override
	public void downloadBuildingInformationCompleted(int buildingID,
			BuildingDescription[] buildingDescriptions) {

	}

	@Override
	public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {

		String selectedFromList = (String) (lv.getItemAtPosition(arg2));
		SearchBuildings.this.adapter.getItem(arg2);

		// open the detail building immediately
		for (int i = 0; i < _buildings.length; i++) {
			if (_buildings[i].getTitle().equals(selectedFromList)) {
				int id = _buildings[i].getID();
				double longitude = _buildings[i].getLongitude();
				double latitude = _buildings[i].getLatitude();
				String title = _buildings[i].getTitle();

				Intent data = new Intent();
				data.putExtra("address", selectedFromList);
				data.putExtra("id", id);
				data.putExtra("title", title);
				data.putExtra("test", "test");
				data.putExtra("index", 0);
				data.putExtra("longitude", longitude);
				data.putExtra("latitude", latitude);
				// Activity finished ok, return the data
				setResult(RESULT_OK, data);
				super.finish();
			}
		}

	}

	@Override
	public void downloadAllRoutesCompleted(Route[] routes) {

	}

	@Override
	public void downloadRouteInformationCompleted(int route_id,
			RouteInformation routeInformation) {
	}

	@Override
	public void downloadAllCategoriesCompleted(Category[] categories) {
	}

	@Override
	public void downloadBuildingsOfCategoryCompleted(
			Building[] buildingsOfCategory) {
	}

}
