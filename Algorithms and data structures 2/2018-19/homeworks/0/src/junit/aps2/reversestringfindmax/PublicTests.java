package aps2.reversestringfindmax;

import aps2.reversestringfindmax.ReverseStringFindMax;
import junit.framework.TestCase;

/**
 * Add Public Tests to this class. Public tests are written by the Instructor
 * and may be used for grading projects. This source code is made available to
 * students.
 */
public class PublicTests extends TestCase {
	ReverseStringFindMax naloga;

	protected void setUp() throws Exception {
		naloga = new ReverseStringFindMax();
	}
	
	public void testReverseString() {
		assertEquals("tset", naloga.reverseString("test"));
	}
	
	public void testReverseStringEmpty() {
		assertEquals("", naloga.reverseString(""));
	}
	
	public void testReverseStringNull() {
		assertEquals(null, naloga.reverseString(null));
	}

	public void testFindMax() {
		int[] arr = { 1, 1, 2, 6, 24, 120, 720, 5040 };
		int res = naloga.findMax(arr);
		assertEquals(5040, res);
	}
}