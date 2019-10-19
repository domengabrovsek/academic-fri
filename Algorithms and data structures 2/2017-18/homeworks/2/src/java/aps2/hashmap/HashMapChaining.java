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

		int list;

		if(!h.equals((HashFunction.HashingMethod.DivisionMethod)))
		{
			if(!contains(k))
			{
				list = HashFunction.KnuthMethod(k, getTable().length);
				getTable()[list].add(new Element(k, v));
				return true;
			}
		}

		if(h.equals(HashFunction.HashingMethod.DivisionMethod))
		{
			if(!contains(k))
			{
				list = HashFunction.DivisionMethod(k, getTable().length);
				getTable()[list].add(new Element(k, v));
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
	public boolean remove(int k)
	{
		int list;

		if (h.equals(HashFunction.HashingMethod.DivisionMethod))
		{
			list = HashFunction.DivisionMethod(k, getTable().length);
			int size = getTable()[list].size();

			if (size != 0)
			{
				getTable()[list].remove(getTable()[list].indexOf(k));
				return true;
			}
		}

		if (!h.equals(HashFunction.HashingMethod.DivisionMethod))
		{
			list = HashFunction.KnuthMethod(k, getTable().length);
			int size = getTable()[list].size();

			if (size != 0)
			{
				getTable()[list].remove(getTable()[list].indexOf(k));
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
	public boolean contains(int k)
	{
		int list;

		if (h.equals(HashFunction.HashingMethod.DivisionMethod))
		{
			list = HashFunction.DivisionMethod(k, getTable().length);
		}
		else
		{
			list = HashFunction.KnuthMethod(k, getTable().length);
		}

		if (this.getTable()[list].size() != 0)
		{
			for (int i = 0; getTable()[list] != null; i++)
			{
				return this.getTable()[list].get(i).key == k;
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
	public String get(int k)
	{
		int list;

		if (h.equals(HashFunction.HashingMethod.DivisionMethod))
		{
			list = HashFunction.DivisionMethod(k, getTable().length);
		}
		else if(h.equals(HashFunction.HashingMethod.KnuthMethod))
		{
			list = HashFunction.KnuthMethod(k, getTable().length);
		}
		else
		{
			return null;
		}

		if (this.getTable()[list].size() != 0)
		{
			for (int i = 0; this.getTable()[list] != null; i++)
			{
				if (this.getTable()[list].get(i).key != k)
				{
					return null;
				}
				else
				{
					return this.getTable()[list].get(i).value;
				}
			}
		}
		return null;
	}
}

