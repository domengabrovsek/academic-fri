package aps2.hashmap;

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
	
	public void testHashMapChainingAdd() {
		HashMapChaining hm = new HashMapChaining(6, HashFunction.HashingMethod.DivisionMethod);
		hm.add(4000, "Kranj");
		hm.add(6000, "Koper");
		hm.add(8000, "Novo mesto");
		hm.add(10000, "Zagreb");
		
		LinkedList<Element> table[] = hm.getTable();
		assertEquals(Arrays.asList(new Element(6000, "Koper")), table[0]);
		assertEquals(Arrays.asList(), table[1]);
		assertEquals(Arrays.asList(new Element(8000, "Novo mesto")), table[2]);
		assertEquals(Arrays.asList(), table[3]);
		assertEquals(Arrays.asList(new Element(4000, "Kranj"), new Element(10000, "Zagreb")), table[4]);
	}
	
	public void testHashMapChainingContainsGet() {
		HashMapChaining hm = new HashMapChaining(6, HashFunction.HashingMethod.DivisionMethod);
		hm.add(6000, "Koper");
		hm.add(4000, "Kranj");
		
		assertTrue(hm.contains(6000));
		assertFalse(hm.contains(6006));
		assertEquals("Kranj", hm.get(4000));
	}
	
	public void testHashMapOpenAddressingAdd() {
		HashMapOpenAddressing hm =
			new HashMapOpenAddressing(
				7,
				HashFunction.HashingMethod.DivisionMethod,
				HashMapOpenAddressing.CollisionProbeSequence.LinearProbing
			);
		
		hm.add(1, "B");
		hm.add(8, "H");
		hm.add(15, "O");
		
		Element table[] = hm.getTable();
		assertEquals(Integer.MIN_VALUE, table[0].key);
		assertEquals(1, table[1].key);
		assertEquals(8, table[2].key);
		assertEquals(15, table[3].key);
		assertEquals(Integer.MIN_VALUE, table[4].key);
		assertEquals(Integer.MIN_VALUE, table[5].key);
		assertEquals(Integer.MIN_VALUE, table[6].key);
	}
	
	public void testHashMapOpenAddressingContainsGet() {
		HashMapOpenAddressing hm =
			new HashMapOpenAddressing(
				5,
				HashFunction.HashingMethod.DivisionMethod,
				HashMapOpenAddressing.CollisionProbeSequence.LinearProbing
			);

		hm.add(6, "F");
		
		assertTrue(hm.contains(6));
		assertFalse(hm.contains(11));
		assertEquals("F", hm.get(6));
	}
}
