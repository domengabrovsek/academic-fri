package psa.naloga2;

import java.util.Arrays;
import java.util.LinkedList;
import junit.framework.TestCase;

public class PublicTests extends TestCase {
	protected void setUp() throws Exception {
	}

	public void testHashFunctionDivisionMethod() {
		assertEquals(4, HashFunction.DivisionMethod(10, 6));
		assertEquals(0, HashFunction.DivisionMethod(15, 5));
	}
	
	public void testHashFunctionKnuthMethod() {
		assertEquals(1, HashFunction.KnuthMethod(10, 6));
		assertEquals(1, HashFunction.KnuthMethod(15, 5));
	}
	
	public void testHashSetChainingAdd() {
		HashSetChaining hs = new HashSetChaining(5, HashFunction.HashingMethod.DivisionMethod);
		hs.add(6);
		hs.add(7);
		hs.add(8);
		hs.add(11);
		
		LinkedList<Integer> table[] = hs.getTable();
		assertEquals(Arrays.asList(), table[0]);
		assertEquals(Arrays.asList(6,11), table[1]);
		assertEquals(Arrays.asList(7), table[2]);
		assertEquals(Arrays.asList(8), table[3]);
		assertEquals(Arrays.asList(), table[4]);
	}
	
	public void testHashSetChainingContains() {
		HashSetChaining hs = new HashSetChaining(5, HashFunction.HashingMethod.DivisionMethod);
		hs.add(6);
		
		assertTrue(hs.contains(6));
		assertFalse(hs.contains(11));
	}
	
	public void testHashSetOpenAddressingAdd() {
		HashSetOpenAddressing hs =
			new HashSetOpenAddressing(
				7,
				HashFunction.HashingMethod.DivisionMethod,
				HashSetOpenAddressing.CollisionProbeSequence.LinearProbing
			);
		
		hs.add(1);
		hs.add(8);
		hs.add(15);
		
		int table[] = hs.getTable();
		assertEquals(Integer.MIN_VALUE, table[0]);
		assertEquals(1, table[1]);
		assertEquals(8, table[2]);
		assertEquals(15, table[3]);
		assertEquals(Integer.MIN_VALUE, table[4]);
		assertEquals(Integer.MIN_VALUE, table[5]);
		assertEquals(Integer.MIN_VALUE, table[6]);
	}
	
	public void testHashSetOpenAddressingContains() {
		HashSetOpenAddressing hs =
			new HashSetOpenAddressing(
				5,
				HashFunction.HashingMethod.DivisionMethod,
				HashSetOpenAddressing.CollisionProbeSequence.LinearProbing
			);

		hs.add(6);
		
		assertTrue(hs.contains(6));
		assertFalse(hs.contains(11));
	}
}
