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
	private double[][] mP;
	private int[][] mH;

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
	public Viterbi(double probability[][])
	{
		this.probability = probability;
		this.n = probability.length;
		this.m = (int)Math.sqrt(probability[0].length);

		// you can add your own initialization here
		this.mP = new double[this.n + 1][this.m];
		this.mH = new int[this.n + 1][this.m];

		for (int i = 0; i < this.m; i++)
		{
			this.mP[0][i] = 1.0 / this.m;
			this.mH[0][i] = -1;
		}
	}
	
	/**
	 * Calculates path from any initial state to any final state with highest
	 * probability using dynamic programming and memoization.
	 */
	public final void calculateOptimalPath()
	{
		double prob;
		for (int i = 0; i < n; i++)
		{
			for (int j = 0; j < m; j++)
			{
				for (int k = 0; k < m; k++)
				{
					prob = mP[i][j] * probability[i][j * m + k];
					double dest = mP[i + 1][k];
					if (prob > dest)
					{
						mP[i + 1][k] = prob;
						mH[i + 1][k] = j;
					}
				}
			}
		}
	}
	
	/**
	 * @return Index of the optimal node in the last state.
	 */
	public int getOptimalResultingState()
	{
		for (int i = 0; i < mH[n].length; i++)
		{
			if (mH[n][i] == 1)
			{
				return i;
			}
		}
		return -1;
	}
	
	/**
	 * @return List of nodes in the optimal path.
	 */
	public List<Integer> getOptimalPath()
	{
		List<Integer> path = new LinkedList<>();
		for (int i = 1; i < mH.length; i++)
		{
			int idx = -1;
			for (int j = 0; j < mH[i].length; j++)
			{
				if (mH[i][j] > 0) {
					idx = mH[i][j];
					break;
				}
			}
			path.add(idx);
		}

		path.add(0);
		return path;
	}
	
	/**
	 * @return Overall probability of the optimal path.
	 */
	public double getOptimalPathProbability()
	{
		double max = 0;
		for (int i = 0; i < mP[n].length; i++)
		{
			if(mP[n][i] > max)
			{
				max = mP[n][i];
			}
		}

		return max;
	}
	
	/**
	 * @return Intermediate memomization price matrix of size (n+1)*m generated
	 * during dynamic programming calls. It contains best
	 * probabilities for each state for specific node. Probabilities for the
	 * initial state are equal to 1.0/m.
	 */
	public double[][] getMemoizationPriceMatrix()
	{
		return this.mP;
	}
	
	/**
	 * @return Intermediate memomization matrix of size (n+1)*m generated
	 * during dynamic programming calls. For each state for specific node, it
	 * contains the predecessor of the node on the optimal path from the initial
	 * state to the final state. Predecessors of nodes in the first state are
	 * set to -1.
	 */
	public int[][] getMemoizationHistoryMatrix()
	{
		return this.mH;
	}
}