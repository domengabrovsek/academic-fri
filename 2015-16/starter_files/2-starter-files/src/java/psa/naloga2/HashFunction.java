package psa.naloga2;

public class HashFunction {
	public static enum HashingMethod {
		DivisionMethod,
		KnuthMethod
	};
	
	/**
	 * Hash function using division method.
	 * If negative key is given, first multiply it by -1.
	 * 
	 * @param k Key
	 * @param m Table size
	 * @return Index in the table of size m.
	 */
	public static int DivisionMethod(int k, int m) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * Hash function using multiplication method implemented by Knuth:
	 * h(k) = m (k A mod 1)
	 * 
	 * Where A is the inverse golden ratio (\sqrt(5)-1)/2.
	 * Use double precision number type.
	 * If negative key is given, first multiply it by -1.
	 * 
	 * @param k Key
	 * @param m Table size
	 * @return Index in the table of size m.
	 */
	public static int KnuthMethod(int k, int m) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
}
