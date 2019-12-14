package aps2.binomialheap;

import junit.framework.TestCase;

/**
 * insert Public Tests to this class. Public tests are written by the Instructor
 * and may be used for grading projects. This source code is made available to
 * students.
 */

public class PublicTests extends TestCase {
	BinomialHeap heap;
	int cmpsAtStart;
	int cmpsAtEnd;

	protected void setUp() throws Exception {
		heap = new BinomialHeap();
	}
	
	public void testInsert() {
		heap.insert(2);
		assertEquals(2, heap.data.get(0).getKey());
		assertEquals(1, heap.n);
	}
	
	public void testConsolidate() {
		heap.insert(7);
		heap.insert(2);
		heap.insert(1);
		heap.delMin();
		assertEquals(1, heap.data.size());
		assertEquals(2, heap.data.get(0).getKey());
		assertEquals(7, heap.data.get(0).getChildren().get(0).getKey());
	}
	
	public void testMergeTrees() {
		BinomialNode node1 = new BinomialNode(7);
		BinomialNode node2 = new BinomialNode(2);
		BinomialNode node3 = BinomialHeap.mergeTrees(node1, node2);
		assertEquals(2, node3.getKey());
		assertEquals(1, node3.getChildren().size());
		assertEquals(7, node3.getChildren().elementAt(0).getKey());
	}
	
	public void testNegativeNumers() {
		heap.insert(-17);
		heap.insert(-32);
		assertEquals(-32, heap.data.get(0).getKey());
		assertEquals(-17, heap.data.get(0).getChildren().elementAt(0).getKey());
	}
	
	public void testGetMin() {
		heap.insert(-17);
		heap.insert(-32);
		heap.insert(7);
		heap.insert(22);
		heap.insert(-7);
		heap.insert(26);
		assertEquals(-32, heap.getMin());
	}
	
	public void testDelMin() {
		heap.insert(-17);
		heap.insert(-32);
		heap.insert(7);
		heap.insert(22);
		heap.insert(-7);
		heap.insert(26);
		assertEquals(-32, heap.getMin());
		assertTrue(heap.delMin());
		assertEquals(5, heap.n);
		assertEquals(-17, heap.getMin());
	}
}
