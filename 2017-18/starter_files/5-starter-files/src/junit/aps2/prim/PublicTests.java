package aps2.prim;

import aps2.prim.Prim;
import junit.framework.TestCase;

public class PublicTests extends TestCase {
	Prim mst;

	protected void setUp() throws Exception {
	}
	
	public void testCreate() {
		mst = new Prim(2);
		assertEquals(2, mst.data.length);
		assertEquals(2, mst.data[0].length);
		assertEquals(2, mst.data[1].length);
	}
	
	public void testAddEdge() {
		mst = new Prim(2);
		mst.addEdge(0, 1, 2);
		
		assertEquals(2, mst.data[0][1]);
		assertEquals(2, mst.data[1][0]);
		assertEquals(0, mst.data[0][0]);
		assertEquals(0, mst.data[1][1]);
	}
	
	public void testSmallTree() {
		int[][] tree = {{0, 3, 1}, {3, 0, 2}, {1, 2, 0}}; // n=3
		mst = new Prim(tree);
		int[] tmp = mst.computeMST(2); // call Prim's algorithm starting from node 2
		assertEquals(6, tmp[0]); // we first visit the edge 2 -> 0. ie. The edge 2*3+0=6
		assertEquals(7, tmp[1]); // then we visit the edge 2 -> 1. ie. The edge 2*3+1=7
	}
}
