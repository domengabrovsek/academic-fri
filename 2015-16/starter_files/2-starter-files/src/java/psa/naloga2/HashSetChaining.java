package psa.naloga2;

import java.util.LinkedList;

/**
 * Hash set employing chaining on collisions.
 */
public class HashSetChaining {
	private LinkedList<Integer> table[];
	private HashFunction.HashingMethod h;
	
	public HashSetChaining(int m, HashFunction.HashingMethod h) {
		this.h = h;
		this.table = new LinkedList[m];
		for (int i=0; i<table.length; i++) {
			table[i] = new LinkedList<>();
		}
	}
	
	public LinkedList<Integer>[] getTable() {
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

