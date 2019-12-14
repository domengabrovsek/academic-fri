package aps2.hashmap;

import java.util.LinkedList;

/**
 * Hash map employing chaining on collisions.
 */
public class HashMapChaining {
	private LinkedList<Element> table[];
	private HashFunction.HashingMethod h;
	
	public HashMapChaining(int m, HashFunction.HashingMethod h) {
		this.h = h;
		this.table = new LinkedList[m];
		for (int i=0; i<table.length; i++) {
			table[i] = new LinkedList<Element>();
		}
	}
	
	public LinkedList<Element>[] getTable() {
		return this.table;
	}
	
	/**
	 * If the element doesn't exist yet, inserts it into the set.
	 * 
	 * @param k Element key
	 * @param v Element value
	 * @return true, if element was added; false otherwise.
	 */
	public boolean add(int k, String v) {
		int seznam;
		if (!h.equals(HashFunction.HashingMethod.DivisionMethod)) {
			if (!contains(k)) {
				seznam = HashFunction.KnuthMethod(k, getTable().length);
				getTable()[seznam].add(new Element(k,v));
				return true;
			}

		}  if (h.equals(HashFunction.HashingMethod.DivisionMethod)) {
			if (!contains(k)) {
				seznam = HashFunction.DivisionMethod(k, getTable().length);
				getTable()[seznam].add(new Element(k,v));
				return true;
			}
		}
		return false;
	}

	/**
	 * Removes the element from the set.
	 * 
	 * @param k Element key
	 * @return true, if the element was removed; otherwise false
	 */
	public boolean remove(int k) {
		int seznam;

		if (h.equals(HashFunction.HashingMethod.DivisionMethod)) {
			seznam = HashFunction.DivisionMethod(k, getTable().length);
			int velikost = getTable()[seznam].size();
			if (velikost != 0) {
				getTable()[seznam].remove(this.getTable()[seznam].indexOf(k));
				return true;
			}
		}
		if (!h.equals(HashFunction.HashingMethod.DivisionMethod)) {
			seznam = HashFunction.KnuthMethod(k, getTable().length);
			int velikost = getTable()[seznam].size();
			if (velikost != 0) {
				getTable()[seznam].remove(this.getTable()[seznam].indexOf(k));
				return true;
			}
		}
		return false;
	}

	/**
	 * Finds the element.
	 * 
	 * @param k Element key
	 * @return true, if the element was found; false otherwise.
	 */
	public boolean contains(int k) {

        int seznam;
        if (h.equals(HashFunction.HashingMethod.DivisionMethod)) {
            seznam = HashFunction.DivisionMethod(k, getTable().length);
        } else  {
            seznam = HashFunction.KnuthMethod(k, getTable().length);
        }
        if (this.getTable()[seznam].size() != 0) {
            for (int i = 0; this.getTable()[seznam] != null; i++) {
                if (this.getTable()[seznam].get(i).key != k) {
                    return false;
                }else{
                    return true;
                }

            }
        }
        return false;
	}
	
	/**
	 * Maps the given key to its value, if the key exists in the hash map.
	 * 
	 * @param k Element key
	 * @return The value for the given key or null, if such a key does not exist.
	 */
	public String get(int k) {
        int seznam;
        if (h.equals(HashFunction.HashingMethod.DivisionMethod)) {
            seznam = HashFunction.DivisionMethod(k, getTable().length);
        } else  {
            seznam = HashFunction.KnuthMethod(k, getTable().length);
        }
        if (this.getTable()[seznam].size() != 0) {
            for (int i = 0; this.getTable()[seznam] != null; i++) {
                if (this.getTable()[seznam].get(i).key != k) {
                    return null;
                }else{
                    return this.getTable()[seznam].get(i).value;
                }

            }
        }
        return null;
	}
}

