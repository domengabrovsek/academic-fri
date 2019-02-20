package aps2.viterbi;

import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

/**
 * @author matevz
 *
 */
public class Viterbi {
	
	public double probability[][];
	int n; // number of states
	int m; // number of nodes per state
	
	/**
	 * @param probability Matrix of transition probabilities between consecutive
	 * states of size n columns x m^2 rows, where n is the number of states and
	 * m the number of nodes per each state.
	 * 
	 * Example for n=3 and m=2. Let there be nodes A1, A2 on 0th state, B1, B2
	 * on 1st state, and C1, C2 on 2nd state with probabilities:
	 * A1 -> B1: 0.2
	 * A1 -> B2: 0.8
	 * A2 -> B1: 0.0
	 * A2 -> B2: 1.0
	 * B1 -> C1: 0.4
	 * B1 -> C2: 0.6
	 * B2 -> C1: 0.3
	 * B2 -> C2: 0.7
	 * 
	 * is encoded as:
	 * probability[0][0] = 0.2;
	 * probability[0][1] = 0.8;
	 * probability[0][2] = 0.0;
	 * probability[0][3] = 1.0;
	 * probability[1][0] = 0.4;
	 * probability[1][1] = 0.6;
	 * probability[1][2] = 0.3;
	 * probability[1][3] = 0.7;
	 *
	 * For details, consult page:
	 * https://ucilnica.fri.uni-lj.si/mod/assign/view.php?id=13961
	 */
	public Viterbi(double probability[][]){
		this.probability = probability;
		this.n = probability.length;
		this.m = (int)Math.sqrt(probability[0].length);
		
		// you can add your own initialization here
	}
	
	/**
	 * Calculates path from any initial state to any final state with highest
	 * probability using dynamic programming and memoization.
	 */
	public final void calculateOptimalPath() {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * @return Index of the optimal node in the last state.
	 */
	public int getOptimalResultingState() {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * @return List of nodes in the optimal path.
	 */
	public List<Integer> getOptimalPath() {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * @return Overall probability of the optimal path.
	 */
	public double getOptimalPathProbability() {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * @return Intermediate memomization price matrix of size (n+1)*m generated
	 * during dynamic programming calls. It contains best
	 * probabilities for each state for specific node. Probabilities for the
	 * initial state are equal to 1.0/m.
	 */
	public double[][] getMemoizationPriceMatrix() {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * @return Intermediate memomization matrix of size (n+1)*m generated
	 * during dynamic programming calls. For each state for specific node, it
	 * contains the predecessor of the node on the optimal path from the initial
	 * state to the final state. Predecessors of nodes in the first state are
	 * set to -1.
	 */
	public int[][] getMemoizationHistoryMatrix() {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
}
