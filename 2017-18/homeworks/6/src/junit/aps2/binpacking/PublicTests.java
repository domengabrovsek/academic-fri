package aps2.binpacking;

import aps2.binpacking.BinPacking;
import java.util.HashSet;
import junit.framework.TestCase;

public class PublicTests extends TestCase {
	BinPacking bp;

	public static boolean checkBinsAndItemsValidity(int[] items, int[] itemBins, int m) {
		if (items.length != itemBins.length) {
			// each item should be assigned into exactly one bin
			return false;
		}
		
		int[] binCapacity = new int[items.length];		
		for (int i=0; i<items.length; i++) {
			binCapacity[itemBins[i]] += items[i];
		}
		
		for (int curBinCapacity: binCapacity) {
			if (curBinCapacity > m) {
				// bin capacity overflow
				return false;
			}
		}
		
		return true;
	}
	
	public void testBinPackingExactTiny() {
		int[] items = {7,2,7,2,8,8,3,3};
		int m=10;
		bp = new BinPacking(items, m);
		
		int[] res = bp.binPackingExact();
		assertTrue(checkBinsAndItemsValidity(items, res, m));
		HashSet<Integer> uniqueBins = new HashSet();
		for (int bin: res) {
			uniqueBins.add(bin);
		}
		assertEquals(4, uniqueBins.size()); // the optimal number bins is 4, for example {7,3},{7,3},{8,2},{8,2}
	}
	
	public void testBinPackingApproximateTiny() {
		int[] items = {7,2,7,2,8,8,3,3};
		int m=10;
		bp = new BinPacking(items, m);
		
		int[] res = bp.binPackingApproximate();
		assertTrue(checkBinsAndItemsValidity(items, res, m));
		HashSet<Integer> uniqueBins = new HashSet();
		for (int bin: res) {
			uniqueBins.add(bin);
		}
		assertTrue(uniqueBins.size() <= 4*1.23); // you should pack into at most 4.92=4 bins using the heuristics
	}
}
