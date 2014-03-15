package at.bitschmiede.grazwiki;

import android.app.Activity;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.Menu;
import android.widget.ImageView;
import android.widget.TextView;

public class FullScreenImageActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_full_screen_image);
		
		Intent intent = getIntent();
		setTitle(intent.getStringExtra("address"));
		
		GlobalState gs = (GlobalState) getApplication();
		Drawable drawable = gs.getDrawableForFullScreenImage();
		ImageView imageView = (ImageView)this.findViewById(R.id.iv_building_image_big);
		imageView.setImageDrawable(drawable);
		
		TextView tvCopyright = (TextView)this.findViewById(R.id.tv_copyright);
		tvCopyright.setText(intent.getStringExtra("copyright"));
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		//getMenuInflater().inflate(R.menu.full_screen_image, menu);
		return true;
	}

}
