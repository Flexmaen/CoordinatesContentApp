package at.bitschmiede.grazwiki.JSON;


/*
 * For the Jackson Object Mapping.
 * Represents the Images of a Building with title and description
 */
public class BuildingDescription {

	//-- Private Members
	private String _title;
	private String _text;
	private BuildingImage[] _images;

	//-- Getter
	public String getTitle(){return _title;}
	public String getText(){return _text;}
	public BuildingImage[] getImages(){return _images;}

	//-- Setter
	public void setTitle(String val){_title = val;}
	public void setText(String val){_text = val;}
	public void setImages(BuildingImage[] _images){this._images = _images;}

}