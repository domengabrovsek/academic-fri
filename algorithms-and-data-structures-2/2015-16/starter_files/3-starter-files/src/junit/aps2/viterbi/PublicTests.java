package aps2.viterbi;

import aps2.viterbi.Viterbi;
import java.util.Arrays;
import java.util.LinkedList;
import junit.framework.TestCase;

/**
 * insert Public Tests to this class. Public tests are written by the Instructor
 * and may be used for grading projects. This source code is made available to
 * students.
 */

public class PublicTests extends TestCase {
	protected void setUp() throws Exception {
	}
	
	public void testInitialMemoizationState() throws Exception {
		double[][] probabilities = {{1.0, 0.0, 1.0, 0.0}};
		
		Viterbi v = new Viterbi(probabilities);
		v.calculateOptimalPath();
		
		assertEquals(0.5, v.getMemoizationPriceMatrix()[0][0]);
		assertEquals(-1, v.getMemoizationHistoryMatrix()[0][0]);
	}
	
	public void testMemoizationMatrixSmall() throws Exception {
		double[][] probabilities = {{0.2, 0.8, 1.0, 0.0}};
		
		Viterbi v = new Viterbi(probabilities);
		v.calculateOptimalPath();
		
		double[][] memoizationPriceMatrix = {{0.5, 0.5},{0.5, 0.4}};
		int[][] memoizationHistoryMatrix = {{-1, -1}, {1, 0}};
		
		assertTrue(Arrays.equals(memoizationPriceMatrix[0], v.getMemoizationPriceMatrix()[0]));
		assertTrue(Arrays.equals(memoizationPriceMatrix[1], v.getMemoizationPriceMatrix()[1]));
		assertTrue(Arrays.equals(memoizationHistoryMatrix[0], v.getMemoizationHistoryMatrix()[0]));
		assertTrue(Arrays.equals(memoizationHistoryMatrix[1], v.getMemoizationHistoryMatrix()[1]));
	}
	
	public void testOptimalPathSmall() throws Exception {
		double[][] probabilities = {{0.2, 0.8, 1.0, 0.0}};
		Integer[] optimalPath = {1, 0};
		LinkedList<Integer> optPath = new LinkedList(Arrays.asList(optimalPath));
		double optimalPathProbability = 0.5;
		
		Viterbi v = new Viterbi(probabilities);
		v.calculateOptimalPath();
		
		assertEquals(optPath, v.getOptimalPath());
		assertEquals(optimalPathProbability, v.getOptimalPathProbability());
		assertEquals(optimalPath[optimalPath.length-1].intValue(), v.getOptimalResultingState());
	}
}
