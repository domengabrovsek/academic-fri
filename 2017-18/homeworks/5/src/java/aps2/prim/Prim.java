package aps2.prim;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Prim's algorithm to compute the minimum spanning tree on the given graph.
 */
public class Prim {
	int[][] data; // prices of edges in the graph of size n*n
	int n;

	public Prim(int n) {
		data = new int[n][n];
		this.n = n;
	}

	public Prim(int[][] d) {
		data = d;
		n = data.length;
	}

	/**
	 * Adds a bi-directional edge from node i to node j of price d into the cost
	 * matrix.
	 *
	 * @param i Source node
	 * @param j Target node
	 * @param d Price
	 */
	public void addEdge(int i, int j, int d) {
		this.data[i][j] = d;
		this.data[j][i] = d;
	}

	/**
	 * Returns the total cost of the minimum spanning tree. ie. The sum of all
	 * edge weights included in the minimum spanning tree.
	 *
	 * @return The total cost of the minimum spanning tree.
	 */
	public int MSTcost() {
		throw new UnsupportedOperationException("You need to implement this function!");
	}

	/**
	 * Computes the minimum spanning tree on the graph using Prim's algorithm.
	 * If two edges share the same price, follow the edge with the smaller target node index.
	 *
	 * @param source Initial vertex
	 * @return An array of visited edges in the correct order of size n-1. The edge in the array from node u to node v is encoded as u*n+v.
	 */

	public int[] computeMST(int source)
	{
		int[] C = new int[n];
		int[] E = new int[n];

		Set<Integer> Q = new HashSet<>();
		for (int j = 0; j < n; j++)
		{
			E[j] = -1;
			C[j] = Integer.MAX_VALUE;
			Q.add(j);
		}

		C[source] = 0;
		List<Integer> list = new ArrayList<>();

		while (!Q.isEmpty())
		{
			int m = -1;

			for (int i : Q)
			{
				if (m == -1 || (C[i] < C[m]))
				{
					m = i;
				}
			}

			Q.remove(m);
			if (E[m] >= 0)
			{
				int result = Calculate(E[m], n, m);
				list.add(result);
			}

			for (int k = 0; k < n; k++)
			{
				if ((data[m][k] > 0 && Q.contains(k)) && (C[k] > data[m][k]))
				{
					C[k] = data[m][k];
					E[k] = m;
				}
			}
		}
		int[] array = NewArray(list);
		return array;
	}

	private int Calculate(int a, int b, int c)
	{
		int result = (a * b) + c;
		return result;
	}

	private int[] NewArray(List input)
	{
		int size = input.size();
		int[] array = new int[size];

		for(int i = 0; i < size; i++)
		{
			array[i] = (int)input.get(i);
		}

		return array;
	}
}