package at.bitschmiede.grazwiki;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.text.method.ScrollingMovementMethod;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import at.bitschmiede.grazwiki.JSON.Building;
import at.bitschmiede.grazwiki.JSON.BuildingDescription;
import at.bitschmiede.grazwiki.JSON.BuildingImage;
import at.bitschmiede.grazwiki.JSON.Category;
import at.bitschmiede.grazwiki.JSON.DownloadBuildingInformation;
import at.bitschmiede.grazwiki.JSON.DownloadEvents;
import at.bitschmiede.grazwiki.JSON.Route;
import at.bitschmiede.grazwiki.JSON.RouteInformation;

public class DetailBuilding extends Activity implements DownloadEvents,
		OnClickListener {

	private LinearLayout _myGallery;
	private ProgressDialog _progressDialog;
	private BuildingDescription[] _currentBuildingDescription;
	private int _indexOfCurrentDescription;
	private int _idOfBuilding;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		// get the id and address from the intent set in SearchBuildings
		Bundle extras = getIntent().getExtras();
		_idOfBuilding = extras.getInt("buildingid");
		String address = extras.getString("address");
		_indexOfCurrentDescription = extras.getInt("index");

		// set address in menu bar
		setTitle(address);

		// first show the progress dialog while loading data from the net
		_progressDialog = ProgressDialog.show(DetailBuilding.this,
				"Lade Daten...", "Bitte warten bis Daten fertig geladen sind.",
				false, false);

		// now download the building information of the current building
		// ... everything else is done in Event Listener
		DownloadBuildingInformation downloadBuildingInfo = new DownloadBuildingInformation();
		downloadBuildingInfo.addListener(this);
		downloadBuildingInfo.execute(_idOfBuilding);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		return true;
	}

	View insertPhoto(String drawableName) {
		//String host = "http://bitschmiede.no-ip.org/~thas/grazwiki/images/";
		String host = "http://server.url/";
		
		String imageUrl = host + drawableName;

		DisplayMetrics metrics = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(metrics);

		int height = 1000; // heightOfGallery; //metrics.heightPixels;
							// 100*40;
		int width = 10000; // metrics.widthPixels;

		LinearLayout layout = new LinearLayout(getApplicationContext());
		layout.setLayoutParams(new LayoutParams(width, height));
		layout.setGravity(Gravity.CENTER);

		// SmartImageView smartImageView = new
		// SmartImageView(getApplicationContext());
		ImageButton smartImageView = new ImageButton(getApplicationContext());
		smartImageView.setLayoutParams(new LayoutParams(width, height));
		smartImageView.setScaleType(ImageView.ScaleType.FIT_CENTER);
		// smartImageView.setImageUrl(imageUrl);
		smartImageView.setImageBitmap(this.fetchImage(imageUrl));

		smartImageView.setOnClickListener(this);

		layout.addView(smartImageView);
		return layout;
	}

	public Bitmap decodeSampledBitmapFromUri(String path, int reqWidth,
			int reqHeight) {
		Bitmap bm = null;

		// First decode with inJustDecodeBounds=true to check dimensions
		final BitmapFactory.Options options = new BitmapFactory.Options();
		options.inJustDecodeBounds = true;
		BitmapFactory.decodeFile(path, options);

		// Calculate inSampleSize
		options.inSampleSize = calculateInSampleSize(options, reqWidth,
				reqHeight);

		// Decode bitmap with inSampleSize set
		options.inJustDecodeBounds = false;
		bm = BitmapFactory.decodeFile(path, options);

		return bm;
	}

	public int calculateInSampleSize(

	BitmapFactory.Options options, int reqWidth, int reqHeight) {
		// Raw height and width of image
		final int height = options.outHeight;
		final int width = options.outWidth;
		int inSampleSize = 1;

		if (height > reqHeight || width > reqWidth) {
			if (width > height) {
				inSampleSize = Math.round((float) height / (float) reqHeight);
			} else {
				inSampleSize = Math.round((float) width / (float) reqWidth);
			}
		}

		return inSampleSize;
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
		_currentBuildingDescription = buildingDescriptions;
		this.updateData();
	}

	public void buttonOlderEntriesClicked(View v) {
		// does something very interesting
		Intent intentDetail = new Intent(DetailBuilding.this,
				at.bitschmiede.grazwiki.DetailBuilding.class);
		;
		intentDetail.putExtra("address",
				this._currentBuildingDescription[0].getTitle());
		intentDetail.putExtra("buildingid", _idOfBuilding);
		intentDetail.putExtra("index", this._indexOfCurrentDescription + 1);
		startActivityForResult(intentDetail, 1);
	}

	private Bitmap fetchImage(String urlstr) {
		try {
			URL url;
			url = new URL(urlstr);

			HttpURLConnection c = (HttpURLConnection) url.openConnection();
			c.setDoInput(true);
			c.connect();
			InputStream is = c.getInputStream();
			Bitmap img;
			img = BitmapFactory.decodeStream(is);
			return img;
		} catch (MalformedURLException e) {
			Log.d("RemoteImageHandler", "fetchImage passed invalid URL: "
					+ urlstr);
		} catch (IOException e) {
			Log.d("RemoteImageHandler", "fetchImage IO exception: " + e);
		}
		return null;
	}

	// update the gui with the downloaded data
	private void updateData() {

		// close the progress dialog
		_progressDialog.dismiss();
		// initialize the View
		setContentView(R.layout.activity_detail_building);
		_myGallery = (LinearLayout) findViewById(R.id.mygallery);

		// no update the view with the downloaded data
		if (_currentBuildingDescription != null) {

			String text = _currentBuildingDescription[_indexOfCurrentDescription]
					.getText();
			String title = _currentBuildingDescription[_indexOfCurrentDescription].getTitle();

			BuildingImage[] buildingImages = _currentBuildingDescription[_indexOfCurrentDescription]
					.getImages();

			for (int i = 0; i < buildingImages.length; i++) {
				String imageName = buildingImages[i].getImageName();
				_myGallery.addView(insertPhoto(imageName));
			}

			// Creating TextView Variable
			TextView tv = (TextView) findViewById(R.id.tv_description);
			// Set the scrolling method
			tv.setMovementMethod(new ScrollingMovementMethod());
			// Sets the new text to TextView (runtime click event)ann
			tv.setText(text);
			
			// Creating TextView Variable
			TextView tvHeader = (TextView) findViewById(R.id.tv_header2);
			// Set the scrolling method
			tv.setMovementMethod(new ScrollingMovementMethod());
			// Sets the new text to TextView (runtime click event)ann
			tv.setText(title);

		}
	}

	public void loadPhoto(ImageButton imageView, int width, int height) {

		ImageView tempImageView = imageView;

		AlertDialog.Builder imageDialog = new AlertDialog.Builder(this);
		LayoutInflater inflater = (LayoutInflater) this
				.getSystemService(LAYOUT_INFLATER_SERVICE);

		View layout = inflater.inflate(R.layout.custom_fullimage_dialog,
				(ViewGroup) findViewById(R.id.layout_root));
		ImageView image = (ImageView) layout.findViewById(R.id.fullimage);
		image.setImageDrawable(tempImageView.getDrawable());
		imageDialog.setView(layout);
		imageDialog.setPositiveButton("OK",
				new DialogInterface.OnClickListener() {

					public void onClick(DialogInterface dialog, int which) {
						dialog.dismiss();
					}

				});

		imageDialog.create();
		imageDialog.show();
	}

	Drawable drawable_from_url(String url, String src_name)
			throws java.net.MalformedURLException, java.io.IOException {
		return Drawable.createFromStream(
				((java.io.InputStream) new java.net.URL(url).getContent()),
				src_name);
	}

	public static Bitmap getBitmapFromURL(String src) {
		try {
			Log.e("src", src);
			URL url = new URL(src);
			HttpURLConnection connection = (HttpURLConnection) url
					.openConnection();
			connection.setDoInput(true);
			connection.connect();
			InputStream input = connection.getInputStream();
			Bitmap myBitmap = BitmapFactory.decodeStream(input);
			Log.e("Bitmap", "returned");
			return myBitmap;
		} catch (IOException e) {
			e.printStackTrace();
			Log.e("Exception", e.getMessage());
			return null;
		}
	}

	public void newerBuildingClicked(View view) {
		// Kabloey
		this.finish();

	}

	public boolean exists(String URLName) {
		try {
			HttpURLConnection.setFollowRedirects(false);
			HttpURLConnection con = (HttpURLConnection) new URL(URLName)
					.openConnection();
			con.setRequestMethod("HEAD");
			return (con.getResponseCode() == HttpURLConnection.HTTP_OK);
		} catch (Exception e) {
			e.printStackTrace();
			return false;
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
	public void onClick(View arg0) {
		this.loadPhoto((ImageButton) arg0, 1000, 1000);
	}

	@Override
	public void downloadAllCategoriesCompleted(Category[] categories) {
	}

	@Override
	public void downloadBuildingsOfCategoryCompleted(
			Building[] buildingsOfCategory) {
	}
}
