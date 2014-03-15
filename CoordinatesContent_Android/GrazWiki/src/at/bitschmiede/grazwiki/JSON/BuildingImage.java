package at.bitschmiede.grazwiki.JSON;

/*
 * For the Jackson Object Mapping.
 * Represents the Images of a Building with title and description
 */
public class BuildingImage {

	//-- Private Members
	private String _imageName;
	private String _imageDescription;

	//-- Getter
	public String getImageName(){return _imageName;}
	public String getImageDescription(){return _imageDescription;}

	//-- Setter
	public void setImageName(String val){_imageName = val;}
	public void setImageDescription(String val){_imageDescription = val;}

}
