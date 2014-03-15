package at.bitschmiede.grazwiki;

import android.app.Application;
import android.graphics.drawable.Drawable;
import android.util.DisplayMetrics;
import at.bitschmiede.grazwiki.JSON.Building;
import at.bitschmiede.grazwiki.JSON.BuildingDescription;
 
/**
* This is a global POJO that we attach data to which we
* want to use across the application
*/

public class GlobalState extends Application
{
	private String _testMe;
	private Building[] _allBuildings;
	private BuildingDescription[] _currentBuildingDescription;
	
	private Drawable _drawableForFullScreenImage;
	
	private DisplayMetrics _displayMetrics;
	
	public void setDisplayMetrics (DisplayMetrics metrics){
		this._displayMetrics = metrics;
	}
	
	public DisplayMetrics getDisplayMetrics(){
		return this._displayMetrics;
	}
	
	
	public String getTestMe() {
		return _testMe;
	}
	public void setTestMe(String testMe) {
		this._testMe = testMe;
	}
	
	public Drawable getDrawableForFullScreenImage() {
		return _drawableForFullScreenImage;
	}
	public void setDrawableForFullScreenImage(Drawable drawable) {
		this._drawableForFullScreenImage = drawable;
	}
	
	public BuildingDescription[] getCurrentBuildingDescription(){
		return this._currentBuildingDescription;
	}
	
	public void setCurrentBuildingDescription(BuildingDescription[] tCurrentBuildingInfo){
		this._currentBuildingDescription = tCurrentBuildingInfo;
	}
	
	public Building[] getAllBuildings(){ return this._allBuildings; }
	public void setAllBuildings(Building[] buildings) { this._allBuildings = buildings; }
	
}