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
	private int count = 0;

	// private helpers
	private int addOne(int number)
	{
		int one = 1;
		return number + one;
	}

	private int removeOne(int number)
	{
		int one = 1;
		return number - one;
	}

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
	
	PatriciaSetNode(String label, boolean terminal)
	{
		this.label = label;
		this.terminal = terminal;
		this.parent = null;
	}
	
	/**
	 * Adds a given node as a new child.
	 * If a child with the same first outgoing character already exists, insertion
	 * fails. Otherwise returns True.
	 */
	public boolean addChild(PatriciaSetNode node)
	{
		node.parent = this;
		if (firstChild == null)
		{
			firstChild = node;
			count = addOne(count);
			return true;
		}

		else if (node.label.length() == 0 || (firstChild.label.charAt(0) == node.label.charAt(0)))
		{
			return false;
		}

		else if (firstChild.label.charAt(0) >= node.label.charAt(0))
		{
			node.nextSibling = firstChild;
			this.firstChild = node;
			count = addOne(count);
			return true;
		}

		PatriciaSetNode nextNode = firstChild;
		while (nextNode.nextSibling != null && (node.label.charAt(0) > nextNode.nextSibling.label.charAt(0)))
		{
			if (nextNode.nextSibling.label.charAt(0) == node.label.charAt(0))
			{
				return false;
			}

			nextNode = nextNode.nextSibling;
		}

		node.nextSibling = nextNode.nextSibling;
		nextNode.nextSibling = node;
		count = addOne(count);
		return true;
	}

	public void shiftDown(PatriciaSetNode node)
	{
		node.firstChild = this.firstChild;
		node.parent = this;
		this.firstChild = node;
	}

	/**
	 * Removes a child with the given first outgoing character. Returns true, if
	 * a child was removed; otherwise false.
	 */
	public boolean removeChild(char c)
	{
		if (firstChild.label.charAt(0) == c)
		{
			firstChild = firstChild.nextSibling;
			count = removeOne(count);
			return true;
		}

		PatriciaSetNode nextNode = firstChild;
		while (nextNode.nextSibling != null && c > nextNode.label.charAt(0))
		{
			if (nextNode.nextSibling.label.charAt(0) == c)
			{
				nextNode.nextSibling = nextNode.nextSibling.nextSibling;
				count = removeOne(count);
				return true;
			}

			nextNode = nextNode.nextSibling;
		}
		return false;
	}

	/**
	 * Returns the child with the given first character on its label or null, if
	 * such a child doesn't exist.
	 */
	public PatriciaSetNode getChild(char c)
	{
		char emptyChar = ' ';
		PatriciaSetNode nextNode = firstChild;

		if (c == emptyChar)
		{
			return null;
		}

		while (nextNode.nextSibling != null)
		{
			if (nextNode.nextSibling.label.charAt(0) == c)
			{
				return nextNode.nextSibling;
			}
			else if (nextNode.label.charAt(0) == c)
			{
				return nextNode;
			}

			nextNode = nextNode.nextSibling;
		}

		return null;
	}
	
	/**
	 * Returns the number of children.
	 */
	public int countChildren()
	{
		return this.count;
	}
	
	public String getLabel()
	{
		return label;
	}
	
	public void setLabel(String l)
	{
		this.label = l;
	}
	
	public boolean isTerminal()
	{
		return this.terminal;
	}
	
	public void setTerminal(boolean t)
	{
		this.terminal = t;
	}
	
	public PatriciaSetNode getParent()
	{
		return this.parent;
	}
}