package aps2.hashmap;

public class Element {
	public int key;
	public String value;
		
	Element(int key, String value) {
		this.key = key;
		this.value = value;
	}
	
	/**
	 * Two elements are the same, if they have the same key. Ignore the value.
	 */
	@Override
	public boolean equals(Object o) {
		if (o!=null) {
			if (o instanceof Element) {
				return (this.key-((Element)o).key)==0;
			}
		}
		
		return false;
	}
}
