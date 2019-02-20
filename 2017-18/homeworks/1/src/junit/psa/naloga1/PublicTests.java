package psa.naloga1;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

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

	// additional tests
	private BSTSet createTestData()
	{
		List<Integer> numbers = new ArrayList<>(Arrays.asList(20,15,28,7,16,22,40,5,9,18,30,50,2));
		for(int i = 0; i < numbers.size(); i++)
		{
			bst.add(numbers.get(i));
		}
		return bst;
	}

	// test if level order works
	public void test1()
	{
		bst = createTestData();
		assertEquals(Arrays.asList(20, 15, 28, 7, 16, 22, 40, 5, 9, 18, 30, 50,2), bst.traverseLevelOrder());
	}

	// test if removing element without children works
	public void test2()
	{
		bst = createTestData();
		bst.remove(9);
		assertEquals(Arrays.asList(20, 15, 28, 7, 16, 22, 40, 5, 18, 30, 50,2), bst.traverseLevelOrder());
	}

	// test if removing element with one child works
	public void test3()
	{
		bst = createTestData();
		bst.remove(5);
		assertEquals(Arrays.asList(20, 15, 28, 7, 16, 22, 40, 2, 9, 18, 30, 50), bst.traverseLevelOrder());
	}

	// test if removing element with two children works
	public void test4()
	{
		bst = createTestData();
		bst.remove(15);
		assertEquals(Arrays.asList(20, 16, 28, 7, 18, 22, 40, 5, 9, 30, 50, 2), bst.traverseLevelOrder());
	}
}
