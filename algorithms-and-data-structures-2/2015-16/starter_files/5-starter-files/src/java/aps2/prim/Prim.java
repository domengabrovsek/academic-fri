package aps2.prim;

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
		throw new UnsupportedOperationException("You need to implement this function!");
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
	public int[] computeMST(int source) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
}
