package at.bitschmiede.grazwiki;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;
import android.webkit.WebView;

public class ImpressumActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_impressum);

		WebView mywebview = (WebView) findViewById(R.id.webview);
		mywebview.loadUrl("file:///android_asset/impressum_de.html");
		
		setTitle("Impressum");
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		return true;
	}

}
