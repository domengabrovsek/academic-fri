package aps2.suffixarray;

import java.util.HashSet;
import java.util.Set;

public class SuffixArrayIndex {
	private String text; // input string
	private int[] SA;    // suffix array
	
	public int[] getSuffixArray() { return SA; }
	
	SuffixArrayIndex(String text){
		this.text = text;
		this.SA = new int[text.length()];
		construct();
	}
	
	/**
	 * Constructs the suffix array corresponding to the text in expected
	 * O(n log n) suffix comparisons.
	 */
	private void construct() {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * Returns True, if the suffix at pos1 is lexicographically before
	 * the suffix at pos2.
	 * 
	 * @param int pos1
	 * @param int pos2
	 * @return boolean
	 */
	public boolean suffixSuffixCompare(int pos1, int pos2) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * Return True, if the query string is lexicographically lesser or
	 * equal to the suffix string at pos1.
	 * 
	 * @param String query The query string
	 * @param int pos2 Position of the suffix
	 * @return boolean
	 */
	public boolean stringSuffixCompare(String query, int pos2) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * Returns the positions of the given substring in the text using binary
	 * search. The empty query is located at all positions in the text.
	 * 
	 * @param String query The query substring
	 * @return A set of positions where the query is located in the text
	 */
	public Set<Integer> locate(String query) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * Returns the longest substring in the text which repeats at least 2 times
	 * by examining the suffix array.
	 * 
	 * @return The longest repeated substring in the text
	 */
	public String longestRepeatedSubstring() {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * Calculates the length of the longest common prefix of two suffixes.
	 * 
	 * @param int pos1 Position of the first suffix in the text
	 * @param int pos2 Position of the second suffix in the text
	 * @return The number of characters in the common prefix of the first and the second suffix
	 */
	public int longestCommonPrefixLen(int pos1, int pos2) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
}

