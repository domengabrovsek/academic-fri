package aps2.patricia;

import java.util.Stack;
import java.util.Set;
import java.util.TreeSet;

/**
 * @author matevz
 *
 */
public class PatriciaSet {
	PatriciaSetNode root;
	
	PatriciaSet() {
		this.root = new PatriciaSetNode("", false);
	}
	
	public PatriciaSetNode getRoot() {
		return root;
	}
	
	/**
	 * Inserts the given key to PATRICIA tree. Returns false, if such a key
	 * already exists in the tree; otherwise true.
	 */
	public boolean insert(String key) {
		throw new UnsupportedOperationException("You need to implement this function!");
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
	public boolean contains(String key) {
		throw new UnsupportedOperationException("You need to implement this function!");
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
