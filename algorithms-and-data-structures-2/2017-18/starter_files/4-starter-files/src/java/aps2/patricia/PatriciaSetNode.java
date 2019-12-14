package aps2.patricia;

/**
 * @author matevz
 *
 */
public class PatriciaSetNode {
	/**
	 * Label on the incoming edge.
	 * The length of label is always greater than 0, except for the root node,
	 * where the label is empty.
	 */
	private String label;
	
	/**
	 * True, if the node is terminal node (ie. the node corresponding to the inserted key)
	 */
	private boolean terminal;
	
	/**
	 * The parent node.
	 */
	PatriciaSetNode parent;
	
	/**
	 * Linked list of children ordered by their labels.
	 */
	public PatriciaSetNode firstChild;
	public PatriciaSetNode nextSibling;
	
	PatriciaSetNode(String label, boolean terminal) {
		this.label = label;
		this.terminal = terminal;
		this.parent = null;
	}
	
	/**
	 * Adds a given node as a new child.
	 * If a child with the same first outgoing character already exists, insertion
	 * fails. Otherwise returns True.
	 */
	public boolean addChild(PatriciaSetNode node) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * Removes a child with the given first outgoing character. Returns true, if
	 * a child was removed; otherwise false.
	 */
	public boolean removeChild(char c) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * Returns the child with the given first character on its label or null, if
	 * such a child doesn't exist.
	 */
	public PatriciaSetNode getChild(char c) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * Returns the number of children.
	 */
	public int countChildren() {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	public String getLabel() {
		return label;
	}
	
	public void setLabel(String l) {
		this.label = l;
	}
	
	public boolean isTerminal() {
		return this.terminal;
	}
	
	public void setTerminal(boolean t) {
		this.terminal = t;
	}
	
	public PatriciaSetNode getParent() {
		return this.parent;
	}
	
	public void setParent(PatriciaSetNode parent) {
		this.parent = parent;
	}
}
