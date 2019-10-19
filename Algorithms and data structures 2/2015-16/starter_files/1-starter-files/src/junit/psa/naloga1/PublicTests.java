package psa.naloga1;

import java.util.Arrays;
import junit.framework.TestCase;

public class PublicTests extends TestCase {
	private BSTSet bst;

	protected void setUp() throws Exception {
		bst = new BSTSet();
		
	}

	public void testBSTSetContains() {
		bst.add(5);
		bst.add(2);
		bst.add(1);
		bst.add(4);
		bst.add(9);
		bst.add(4);
		assertTrue(bst.contains(9));
	}
	
	public void testBSTSetNotContains() {
		bst.add(5);
		bst.add(2);
		bst.add(1);
		bst.add(4);
		bst.add(9);
		bst.add(4);
		assertFalse(bst.contains(3));
	}
	
	public void testBSTRemove() {
		bst.add(5);
		bst.add(2);
		bst.add(1);
		bst.add(4);
		bst.add(9);
		bst.add(4);
		assertTrue(bst.remove(4));
		assertFalse(bst.contains(4));
	}
	
	public void testBSTNumberOfCompares() {
		bst.add(1);
		bst.add(2);
		bst.add(3);
		bst.add(4);
		bst.resetCounter();
		bst.contains(4);
		assertEquals(4, bst.getCounter());
	}
	
	public void testBSTTraversePreOrder() {
		bst.add(4); // root
		bst.add(2);
		bst.add(6);
		bst.add(1);
		bst.add(3);
		bst.add(5);
		bst.add(7);
		assertEquals(Arrays.asList(4, 2, 1, 3, 6, 5, 7), bst.traversePreOrder());
	}
}
