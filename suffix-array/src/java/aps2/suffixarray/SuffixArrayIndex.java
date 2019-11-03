package aps2.suffixarray;

import java.util.*;

public class SuffixArrayIndex {
	private String text; // input string
	private int[] SA;    // suffix array
    private HashMap<String, Integer> suffixIndexes;

	public int[] getSuffixArray() { return SA; }
	
	SuffixArrayIndex(String text){
		this.text = text;
		this.SA = new int[text.length()];
		this.suffixIndexes = new HashMap();
		construct();
	}

    private int findIndex(int position){
        int index = -1;
        for(int i = 0; i < this.SA.length; i++){
            if(position == this.SA[i]){
                index = i;
                break;
            }
        }
        return index;
    }

	/**
	 * Constructs the suffix array corresponding to the text in expected
	 * O(n log n) suffix comparisons.
	 */
	private void construct() {
	    ArrayList<String> array = new ArrayList<>();

	    // create array of all suffixes
	    for(int i = 0; i < this.text.length(); i++){
	        int end = this.text.length();
            int start = i;

            // suffix we're currently processing
	        String suffix = this.text.substring(start, end);

	        // add suffix to hashmap of (suffix -> start index)
            this.suffixIndexes.put(suffix, start);

	        // add suffix to array
	        array.add(suffix);
        }

        // sort suffixed alphabetically
        Collections.sort(array, (a, b) -> a.compareToIgnoreCase(b));

        // create suffix array
        for(int i = 0; i < array.size(); i++) {
            this.SA[i] = this.suffixIndexes.get(array.get(i));
        }
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

	    int indexOne = findIndex(pos1);
	    int indexTwo = findIndex(pos2);

	    return indexOne < indexTwo;
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

	    int indexOne = findIndex(this.suffixIndexes.get(query));
	    int indexTwo = findIndex(pos2);

	    return indexOne <= indexTwo;
	}
	
	/**
	 * Returns the positions of the given substring in the text using binary
	 * search. The empty query is located at all positions in the text.
	 * 
	 * @param String query The query substring
	 * @return A set of positions where the query is located in the text
	 */
	public Set<Integer> locate(String query) {
        Set<Integer> locations = new HashSet();

	    // if query is empty return all locations of text
	    if(query.length() == 0 || query == null || query.equals("")){
	        for(int i = 0; i < this.text.length(); i++){
                locations.add(i);
            }
	        return locations;
        }

        // if query is not empty go through all elements in suffix array
        for(int i = 0; i < this.SA.length; i++){
            int index = this.SA[i];
            String element = this.text.substring(index, index + query.length());
            if(element.equals(query)){
                System.out.println(element);
                locations.add(index);
            }
        }

        return locations;
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

