package at.bitschmiede.grazwiki;

import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.text.method.ScrollingMovementMethod;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import at.bitschmiede.grazwiki.JSON.BuildingDescription;
import at.bitschmiede.grazwiki.JSON.BuildingImage;

public class BSViewPageAdapter extends PagerAdapter implements OnClickListener {
	List<View> pages = null;
	int noOfPages = 0;
	int currentPage = -1;
	private String _buildingAdress = null;
	View _view = null;
	GlobalState _globalState = null;
	int _currentImageIndex = -1;

	ArrayList<Integer> _dynamicCurrentImageIndex = new ArrayList<Integer>();
	HashMap<String, Integer> _mapCurrentImageIndex = new HashMap<String, Integer>();
	HashMap<String, Object> _mapViewList = new HashMap<String, Object>();

	public BSViewPageAdapter(List<View> pages) {
		this.pages = pages;
	}

	public BSViewPageAdapter(int noPages) {
		this.noOfPages = noPages;
	}

	@Override
	public int getCount() {
		if (pages != null)
			return pages.size();
		else
			return noOfPages;
	}

	@Override
	public boolean isViewFromObject(View view, Object object) {
		return view.equals(object);

	}

	@Override
	public Object instantiateItem(View collection, int position) {

		LayoutInflater inflater = (LayoutInflater) collection.getContext()
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		int resId;
		int version = 8; // android.os.Build.VERSION.SDK_INT;

		if (version < android.os.Build.VERSION_CODES.HONEYCOMB) {
			// only for gingerbread and older versions
			resId = R.layout.fragment_detail_building_gingerbread;
			// set listeners for buttons
		} else {
			resId = R.layout.fragment_detail_building;
		}

		View viewContext = inflater.inflate(resId, null);
		this._globalState = (GlobalState) viewContext.getContext()
				.getApplicationContext();
		BuildingDescription[] currentBuildingDescription = this._globalState
				.getCurrentBuildingDescription();
		int revisions = currentBuildingDescription.length;
		// loop through every revision and add all data to the asociated
		// fragment

		View view = inflater.inflate(resId, null);
		this._view = view;
		Button leftButton = null;
		Button rightButton = null;
		if (version < android.os.Build.VERSION_CODES.HONEYCOMB) {
			// only for gingerbread and older versions
			// set listeners for buttons
			leftButton = (Button) view.findViewById(R.id.btn_left);
			rightButton = (Button) view.findViewById(R.id.btn_right);
			leftButton.setOnClickListener(this);
			rightButton.setOnClickListener(this);
		} else {
			// to nothing
		}

		String text = currentBuildingDescription[position].getText();
		// Creating TextView Variable
		TextView tv = (TextView) view.findViewById(R.id.tv_description);
		// Set the scrolling method
		tv.setMovementMethod(new ScrollingMovementMethod());
		// Sets the new text to TextView (runtime click event)ann
		tv.setText(text);

		String title = "  " + currentBuildingDescription[position].getTitle();
		
		// Creating TextView Variable
		TextView tvHeader = (TextView) view.findViewById(R.id.tv_header2);
		// Sets the new text to TextView (runtime click event)ann
		//String sHeader = "  Beschreibung " + String.valueOf(position + 1) + "/"
		//		+ String.valueOf(revisions);
		tvHeader.setText(title);
		String host = "http://www.server.url/";
		BuildingImage[] buildingImages = currentBuildingDescription[position]
				.getImages();
		int length = buildingImages.length;

		if (length <= 1) {
			leftButton.setEnabled(false);
			rightButton.setEnabled(false);
		} else {
			leftButton.setEnabled(true);
			rightButton.setEnabled(true);
		}

		if (length > 0)
			length = 1;

		for (int j = 0; j < length /* buildingImages.length; */; j++) {
			String imageName = buildingImages[j].getImageName();
			String imageUrl = host + imageName;
			this._currentImageIndex = j;
			this._dynamicCurrentImageIndex.add(j);
			this._mapCurrentImageIndex.put(Integer.toString(position), j);
			ImageButton imageButton = (ImageButton) view
					.findViewById(R.id.ib_ginger_building_image);
			imageButton.setOnClickListener(this);
			new DownloadImageButtonTask(imageButton).execute(imageUrl);

			this.checkButtonsToHide(view, j, buildingImages.length);
		}

		this.checkSwipeTextToHide(view, position, revisions);

		((ViewPager) collection).addView(view, 0);
		this._mapViewList.put(Integer.toString(position), view);
		return view;
	}

	@Override
	public void destroyItem(View collection, int position, Object view) {
		((ViewPager) collection).removeView((View) view);
	}

	public void setIndexOfActiveView(int position) {
		this.currentPage = position;
	}

	public int getIndexOfActiveView() {
		return this.currentPage;
	}

	@SuppressWarnings("deprecation")
	View insertPhoto(String drawableName, String description, View view,
			int indexOfImage) {

		String host = "http://www.server.url/";
		String imageUrl = host + drawableName;

		// get the metrics of the device via the global state,
		// because we have no access to the application from here
		GlobalState gs = (GlobalState) view.getContext()
				.getApplicationContext();
		DisplayMetrics metrics = gs.getDisplayMetrics();

		int height = metrics.heightPixels / 100 * 40;
		height = height / 100 * 40;

		LinearLayout layout = new LinearLayout(view.getContext());
		layout.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT,
				LayoutParams.FILL_PARENT));
		layout.setGravity(Gravity.CENTER);
		layout.setPadding(0, 0, 0, 0);
		layout.setBackgroundColor(Color.CYAN);
		layout.setOrientation(LinearLayout.VERTICAL);

		ImageButton smartImageView = new ImageButton(view.getContext());
		smartImageView.setLayoutParams(new LayoutParams(
				LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT));
		smartImageView.setBackgroundColor(Color.TRANSPARENT);
		smartImageView.setScaleType(ImageView.ScaleType.FIT_CENTER);
		smartImageView.setId(indexOfImage);
		smartImageView.setOnClickListener(this);

		new DownloadImageButtonTask(smartImageView).execute(imageUrl);

		layout.addView(smartImageView);
		return layout;
	}

	@SuppressWarnings("deprecation")
	View insertPhotoGingerbread(String drawableName, String description,
			View view, int indexOfImage) {

		String host = "http://www.server.url/";
		String imageUrl = host + drawableName;

		// get the metrics of the device via the global state,
		// because we have no access to the a bipplication from here
		GlobalState gs = (GlobalState) view.getContext()
				.getApplicationContext();
		DisplayMetrics metrics = gs.getDisplayMetrics();

		int height = metrics.heightPixels / 100 * 40;
		height = height / 100 * 40;

		LinearLayout layout = new LinearLayout(view.getContext());
		layout.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT,
				LayoutParams.FILL_PARENT));
		layout.setGravity(Gravity.CENTER);
		layout.setPadding(0, 0, 0, 0);
		layout.setBackgroundColor(Color.CYAN);
		layout.setOrientation(LinearLayout.HORIZONTAL);

		ImageButton smartImageView = new ImageButton(view.getContext());
		smartImageView.setLayoutParams(new LayoutParams(
				LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT));
		smartImageView.setBackgroundColor(Color.TRANSPARENT);
		smartImageView.setScaleType(ImageView.ScaleType.FIT_CENTER);
		smartImageView.setId(indexOfImage);

		smartImageView.setOnClickListener(this);

		new DownloadImageButtonTask(smartImageView).execute(imageUrl);

		Button button = new Button(view.getContext());
		button.setLayoutParams(new LayoutParams(LayoutParams.WRAP_CONTENT,
				LayoutParams.WRAP_CONTENT));
		button.setText("LEFT");
		button.setBackgroundColor(Color.TRANSPARENT);

		button.setOnClickListener(this);
		layout.addView(button);

		layout.addView(smartImageView);

		Button buttonRight = new Button(view.getContext());
		buttonRight.setLayoutParams(new LayoutParams(LayoutParams.WRAP_CONTENT,
				LayoutParams.WRAP_CONTENT));
		buttonRight.setText("Right");
		buttonRight.setBackgroundColor(Color.TRANSPARENT);

		button.setOnClickListener(this);
		layout.addView(button);
		layout.addView(smartImageView);

		return layout;
	}

	public void setBuildingAdress(String address) {
		this._buildingAdress = address;
	}

	public boolean urlExists(String URLName) {
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

	class DownloadImageButtonTask extends AsyncTask<String, Void, Bitmap> {
		ImageView bmImage;

		public DownloadImageButtonTask(ImageButton bmImage) {
			this.bmImage = bmImage;
		}

		protected Bitmap doInBackground(String... urls) {
			String urldisplay = urls[0];
			Bitmap mIcon11 = null;
			try {
				InputStream in = new java.net.URL(urldisplay).openStream();
				mIcon11 = BitmapFactory.decodeStream(in);
			} catch (Exception e) {
				if (e.getMessage() != null) {
					Log.e("Error", e.getMessage());
					e.printStackTrace();
				}
			}
			return mIcon11;
		}

		protected void onPostExecute(Bitmap result) {
			bmImage.setImageBitmap(result);
		}
	}

	@Override
	public void onClick(View v) {

		BuildingDescription[] currentBuildingDescription = this._globalState
				.getCurrentBuildingDescription();
		BuildingImage[] buildingImages = currentBuildingDescription[this.currentPage]
				.getImages();

		ImageButton imageButton;
		int sizeOfImageArray;
		int previousImageIndex;
		int nextImageIndex;
		String host = "http://www.server.url/";
		String url;
		String imageName;
		View tView = (View) this._mapViewList.get(Integer
				.toString(this.currentPage));

		switch (v.getId()) {

		case R.id.btn_left:

			imageButton = (ImageButton) tView
					.findViewById(R.id.ib_ginger_building_image);

			sizeOfImageArray = buildingImages.length;
			previousImageIndex = this._mapCurrentImageIndex.get(Integer
					.toString(this.currentPage)) - 1;
			// return if image index is not available, index < 0
			if (previousImageIndex < 0)
				return;
			// return if next image is bigger then the array
			if (previousImageIndex >= sizeOfImageArray)
				return;
			// set the new image
			imageName = buildingImages[previousImageIndex].getImageName();

			url = host + imageName;
			new DownloadImageButtonTask(imageButton).execute(url);
			this._mapCurrentImageIndex.put(Integer.toString(this.currentPage),
					previousImageIndex);

			this.checkButtonsToHide(tView, previousImageIndex, sizeOfImageArray);

			break;
		case R.id.btn_right:

			imageButton = (ImageButton) tView
					.findViewById(R.id.ib_ginger_building_image);

			sizeOfImageArray = buildingImages.length;
			nextImageIndex = this._mapCurrentImageIndex.get(Integer
					.toString(this.currentPage)) + 1;
			// return if image index is not available, index < 0
			if (nextImageIndex < 0)
				return;
			// return if next image is bigger then the array
			if (nextImageIndex >= sizeOfImageArray)
				return;
			// set the new image
			imageName = buildingImages[nextImageIndex].getImageName();

			url = host + imageName;
			new DownloadImageButtonTask(imageButton).execute(url);
			this._mapCurrentImageIndex.put(Integer.toString(this.currentPage),
					nextImageIndex);

			this.checkButtonsToHide(tView, nextImageIndex, sizeOfImageArray);

			break;
		default:

			GlobalState gs = (GlobalState) v.getContext()
					.getApplicationContext();
			ImageButton button = (ImageButton) v;
			Drawable drawableFromButton = button.getDrawable();

			BuildingImage[] images = currentBuildingDescription[this.currentPage]
					.getImages();
			int imageIndex = this._mapCurrentImageIndex.get(Integer
					.toString(this.currentPage));
			String sCopyright = images[imageIndex].getImageDescription();
			gs.setDrawableForFullScreenImage(drawableFromButton);

			Intent imageActivity = new Intent(v.getContext(),
					at.bitschmiede.grazwiki.FullScreenImageActivity.class);
			imageActivity.putExtra("address", this._buildingAdress);
			imageActivity.putExtra("copyright", sCopyright);
			v.getContext().startActivity(imageActivity);

			break;

		}

		return;
	}

	public void checkButtonsToHide(View view, int currentImageIndex,
			int sizeOfArray) {

		// check if buttons are to hide!
		Button leftButton = (Button) view.findViewById(R.id.btn_left);
		Button rightButton = (Button) view.findViewById(R.id.btn_right);

		sizeOfArray = sizeOfArray - 1; // correct size

		// return if image index is not valid
		if (currentImageIndex < 0)
			return;

		if (currentImageIndex < sizeOfArray) {
			rightButton.setEnabled(true);
		}

		if (currentImageIndex == sizeOfArray) {
			rightButton.setEnabled(false);
		}

		if (currentImageIndex > 0 && currentImageIndex < sizeOfArray) {
			leftButton.setEnabled(true);
		}

		if (currentImageIndex > 0)
			leftButton.setEnabled(true);

		if (currentImageIndex == 0) {
			leftButton.setEnabled(false);
		}
	}

	public void checkSwipeTextToHide(View view, int currentPageIndex,
			int countOfPages) {

		// Creating TextView Variable
		TextView tvPages = (TextView) view.findViewById(R.id.tv_pages);
		String infoText = "";

		countOfPages = countOfPages - 1; // correct count/size

		ImageButton leftButton = (ImageButton) view
				.findViewById(R.id.ib_left_arrow);
		ImageButton rightButton = (ImageButton) view
				.findViewById(R.id.ib_right_arrow);

		if (currentPageIndex == countOfPages) {
			rightButton.setVisibility(View.GONE);
			leftButton.setVisibility(View.GONE);
		}

		if (currentPageIndex == 0 && countOfPages >= 1) {
			infoText = "Nach links wischen für ältere Version";
			rightButton.setVisibility(View.GONE);
			leftButton.setVisibility(View.VISIBLE);
		}

		if (currentPageIndex > 0 && currentPageIndex < countOfPages) {
			infoText = "Nach links/recht wischen für ältere/neure Version";
			rightButton.setVisibility(View.VISIBLE);
			leftButton.setVisibility(View.VISIBLE);
		}

		if (currentPageIndex > 0 && currentPageIndex == countOfPages) {
			infoText = "Nach rechts wischen für neure Version";
			rightButton.setVisibility(View.VISIBLE);
			leftButton.setVisibility(View.GONE);
		}

		tvPages.setText(infoText);

	}

	public void rightClicked(View v) {

	}

	public void leftClicked(View v) {

	}
}