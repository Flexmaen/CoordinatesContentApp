package at.bitschmiede.grazwiki;

import android.app.ProgressDialog;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v4.view.ViewPager;
import android.view.Menu;
import android.widget.TextView;
import at.bitschmiede.grazwiki.JSON.Building;
import at.bitschmiede.grazwiki.JSON.BuildingDescription;
import at.bitschmiede.grazwiki.JSON.Category;
import at.bitschmiede.grazwiki.JSON.DownloadBuildingInformation;
import at.bitschmiede.grazwiki.JSON.DownloadEvents;
import at.bitschmiede.grazwiki.JSON.Route;
import at.bitschmiede.grazwiki.JSON.RouteInformation;

public class DetailBuildingContainer extends FragmentActivity implements
		DownloadEvents {

	private ProgressDialog _progressDialog;
	private int _idOfBuilding;
	GlobalState _globalState = null;
	private String _buildingAddress = null;
	BSViewPageAdapter adapter = null;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		this._globalState = (GlobalState) getApplication();
		// first show the progress dialog while loading data from the net
		_progressDialog = ProgressDialog.show(DetailBuildingContainer.this,
				"Lade Daten...", "Bitte warten bis Daten fertig geladen sind.",
				false, false);

		// get the id and address from the intent set in SearchBuildings
		Bundle extras = getIntent().getExtras();
		_idOfBuilding = extras.getInt("buildingid");
		String address = extras.getString("address");

		// now download the building information of the current building
		// ... everything else is done in Event Listener
		DownloadBuildingInformation downloadBuildingInfo = new DownloadBuildingInformation();
		downloadBuildingInfo.addListener(this);
		downloadBuildingInfo.execute(_idOfBuilding);

		// set menu bar title
		setTitle("Detailinformationen");
		// set Adress Text View
		setContentView(R.layout.activity_detail_building_container);
		TextView tvAddress = (TextView) this
				.findViewById(R.id.tv_building_name);
		tvAddress.setText(address);
		this._buildingAddress = address;

	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		return true;
	}

	@Override
	public void downloadBuildingsOfRegionCompleted(Building[] buildingsInRegion) {
	}

	@Override
	public void downloadAllBuildingsCompleted(Building[] buildingsInRegion) {
	}

	@Override
	public void downloadBuildingInformationCompleted(int buildingID,
			BuildingDescription[] buildingDescriptions) {
		this._globalState.setCurrentBuildingDescription(buildingDescriptions);
		_progressDialog.dismiss();

		if (buildingDescriptions == null) {
			this.finish();
			return;
		}
		this.updateViewsData();
	}

	public void updateViewsData() {

		int revisionsOBuilding = this._globalState
				.getCurrentBuildingDescription().length;
		if (revisionsOBuilding != 0) {
			adapter = new BSViewPageAdapter(revisionsOBuilding);
			ViewPager myPager = (ViewPager) findViewById(R.id.pager);
			myPager.setAdapter(adapter);
			adapter.setBuildingAdress(this._buildingAddress);
			myPager.setCurrentItem(0);
			adapter.setIndexOfActiveView(0);

			myPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
				@Override
				public void onPageScrolled(int i, float v, int i2) {
				}

				@Override
				public void onPageSelected(int i) {
					adapter.setIndexOfActiveView(i);
				}

				@Override
				public void onPageScrollStateChanged(int i) {

				}
			});
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
