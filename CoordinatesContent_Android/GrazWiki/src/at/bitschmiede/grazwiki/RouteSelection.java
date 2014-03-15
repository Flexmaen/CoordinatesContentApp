package at.bitschmiede.grazwiki;

import java.util.ArrayList;
import java.util.HashMap;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import at.bitschmiede.grazwiki.JSON.Building;
import at.bitschmiede.grazwiki.JSON.BuildingDescription;
import at.bitschmiede.grazwiki.JSON.Category;
import at.bitschmiede.grazwiki.JSON.DownloadAllRoutes;
import at.bitschmiede.grazwiki.JSON.DownloadEvents;
import at.bitschmiede.grazwiki.JSON.Route;
import at.bitschmiede.grazwiki.JSON.RouteInformation;

public class RouteSelection extends Activity implements DownloadEvents,
		OnItemClickListener {

	Route[] _routes = null;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_route_selection);

		setTitle("Routenauswahl");

		DownloadAllRoutes downloadAllRoutes = new DownloadAllRoutes();
		downloadAllRoutes.addListener(this);
		downloadAllRoutes.execute();

	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.route_selection, menu);
		return true;
	}

	private void fillListView() {

		ListView list = (ListView) this.findViewById(R.id.LV_ROUTE_SELECTION);

		ArrayList<HashMap<String, String>> mylist = new ArrayList<HashMap<String, String>>();

		for (int i = 0; i < this._routes.length; i++) {
			HashMap<String, String> map = new HashMap<String, String>();
			String id = Integer.toString(this._routes[i].getId());
			String listIndex = Integer.toString(i);
			String title = this._routes[i].getTitle();
			String description = this._routes[i].getDescription();
			map.put("id", id);
			map.put("listindex", listIndex);
			map.put("title", title);
			map.put("description", description);
			mylist.add(map);
		}

		SimpleAdapter mySimpleAdapter = new SimpleAdapter(this, mylist,
				R.layout.row_routes, new String[] { "title", "description" },
				new int[] { R.id.TV_ROUTE_NAME, R.id.TV_ROUTE_DESCRIPTION });
		list.setAdapter(mySimpleAdapter);
		list.setOnItemClickListener(this);

	}

	@Override
	public void downloadBuildingsOfRegionCompleted(Building[] buildingsInRegion) {
	}

	@Override
	public void downloadAllBuildingsCompleted(Building[] buildingsInRegion) {
	}

	@Override
	public void downloadAllRoutesCompleted(Route[] routes) {
		this._routes = routes;
		this.fillListView();
	}

	@Override
	public void downloadRouteInformationCompleted(int route_id,
			RouteInformation routeInformation) {
	}

	@Override
	public void downloadBuildingInformationCompleted(int buildingID,
			BuildingDescription[] buildingDescriptions) {
	}

	@Override
	public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
		int id = this._routes[arg2].getId();
		Intent resultData = new Intent();
		resultData.putExtra("routeID", Integer.toString(id));
		setResult(Activity.RESULT_OK, resultData);
		finish();

	}

	@Override
	public void downloadAllCategoriesCompleted(Category[] categories) {
	}

	@Override
	public void downloadBuildingsOfCategoryCompleted(
			Building[] buildingsOfCategory) {
	}

}
