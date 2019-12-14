package aps2.binpacking;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

/**
 * Bin packing algorithm to compute the minimum number of bins to store all the
 * given items.
 */
public class BinPacking {
	int[] items; // sizes of items to store
	int m; // size of each bin

	public BinPacking(int[] items, int m) {
		this.items = items;
		this.m = m;
	}

	/**
	 * Computes the strictly minimal number of bins for the given items.
	 * 
	 * @return Array of size n which stores the index of bin, where each item is stored in.
	 */
	public int[] binPackingExact() {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * Uses heuristics (e.g. first-fit, best-fit, ordered first-fit etc.) to
	 * compute the minimal number of bins for the given items. The smaller the
	 * number, the more tests you will pass.
	 * 
	 * @return Array of size n which stores the index of bin, where each item is stored in.
	 */
	public int[] binPackingApproximate() {
		throw new UnsupportedOperationException("You need to implement this function!");
	}

}
