package aps2.patricia;

import java.util.Set;

/**
 * @author matevz
 *
 */
public class PatriciaSet {
	PatriciaSetNode root;

	PatriciaSet()
	{
		this.root = new PatriciaSetNode("", false);
	}

	public PatriciaSetNode getRoot()
	{
		return root;
	}
	
	/**
	 * Inserts the given key to PATRICIA tree. Returns false, if such a key
	 * already exists in the tree; otherwise true.
	 */
	public boolean insert(String key)
	{
		PatriciaSetNode previous = root;
		PatriciaSetNode current = root.firstChild;
		String common = "";
		StringBuilder diff = new StringBuilder();

		while (current != null)
		{
			if(current.getLabel().length() > 0 && (key.length() > 0 && current.getLabel().charAt(0) == key.charAt(0)))
			{
				int i = 0;
				while(i < Math.min(key.length(), current.getLabel().length()))
				{
					if (current.getLabel().charAt(i) != key.charAt(i))
					{
						break;
					}
					i++;
				}

				common = key.substring(0, i);

				String substring = current.getLabel().substring(i);
				diff.append(substring);

				key = key.substring(i);
				previous = current;
				current = current.firstChild;
			}
			else
			{
				current = current.nextSibling;
			}
		}

		if(diff.toString().length() > 0)
		{
			previous.shiftDown(new PatriciaSetNode(diff.toString(),true));
			previous.setLabel(common);
			previous.setTerminal(false);
		}

		PatriciaSetNode child = new PatriciaSetNode(key, true);
		return previous.addChild(child);
	}

	/**
	 * Inserts the given key from PATRICIA tree. Returns false, if a key didn't
	 * exist or wasn't a terminal node; otherwise true.
	 */
	public boolean remove(String key) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * Returns true, if the given key exists in PATRICIA tree and is a terminal
	 * node; otherwise false.
	 */
	public boolean contains(String key)
	{
		PatriciaSetNode next = root.firstChild;
		while (next != null)
		{
			if (key.startsWith(next.getLabel()))
			{
				key = key.substring(next.getLabel().length());
				if(key.length() == 0)
				{
					return next.isTerminal();
				}

				next = next.firstChild;
			}
			else
			{
				next = next.nextSibling;
			}
		}
		return false;
	}
	
	/**
	 * Returns the longest prefix of the given string which still exists in
	 * PATRICIA tree.
	 */
	public String longestPrefixOf(String s) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * Returns all stored strings with the given prefix.
	 */
	public Set<String> keysWithPrefix(String s) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * Returns the node with the largest string-depth which is not a leaf.
	 * String-depth is the sum of label lengths on that root-to-node path.
	 * This node also corresponds to the longest common prefix of at least two
	 * inserted strings.
	 */
	public PatriciaSetNode getLongestPrefixNode() {
		throw new UnsupportedOperationException("You need to implement this function!");
	}

	/**
	 * Computes and returns the longest substring in the given text repeated at
	 * least 2 times by finding the deepest node.
	 */
	public static String longestRepeatedSubstring(String text) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
}
