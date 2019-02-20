package psa.naloga2;

/**
 * Hash set with open addressing.
 */
public class HashSetOpenAddressing {
	private int table[]; // table content, Integer.MIN_VALUE, if element not present
	private HashFunction.HashingMethod h;
	private CollisionProbeSequence c;
	
	public static enum CollisionProbeSequence {
		LinearProbing, // new h(k) = (h(k) + i) mod m
		QuadraticProbing, // new h(k) = (h(k) + i^2) mod m
		DoubleHashing // new h(k) = (h(k) + i*h(k)) mod m
	};
	
	public HashSetOpenAddressing(int m, HashFunction.HashingMethod h, CollisionProbeSequence c) {
		this.table = new int[m];
		this.h = h;
		this.c = c;
		
		// init empty slot as MIN_VALUE
		for (int i=0; i<m; i++) {
			table[i] = Integer.MIN_VALUE;
		}
	}

	public int[] getTable() {
		return this.table;
	}
	
	/**
	 * If the element doesn't exist yet, inserts it into the set.
	 * 
	 * @param k Element key
	 * @return true, if element was added; false otherwise.
	 */
	public boolean add(int k) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}

	/**
	 * Removes the element from the set.
	 * 
	 * @param k Element key
	 * @return true, if the element was removed; otherwise false
	 */
	public boolean remove(int k) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}

	/**
	 * Finds the element.
	 * 
	 * @param k Element key
	 * @return true, if the element was found; false otherwise.
	 */
	public boolean contains(int k) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
}

