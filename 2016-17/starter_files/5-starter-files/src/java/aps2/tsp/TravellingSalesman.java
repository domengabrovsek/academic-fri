package aps2.tsp;

public class TravellingSalesman {
	/**
	 * To solve the travelling salesman problem (TSP) you need to find a shortest
	 * tour over all nodes in the graph where each node must be visited exactly
	 * once. You need to finish at the origin node.
	 *
	 * In this task we will consider complete undirected graphs only with
	 * Euclidean distances between the nodes.
	 */
	
	/**
	 * Adds a node to a graph with coordinates x and y. Assume the nodes are
	 * named by the order of insertion.
	 * 
	 * @param x X-coordinate
	 * @param y Y-coordinate
	 */
	public void addNode(int x, int y){
		throw new UnsupportedOperationException("You need to implement this function!"); 
	}
	
	/**
	 * Returns the distance between nodes v1 and v2.
	 * 
	 * @param v1 Identifier of the first node
	 * @param v2 Identifier of the second node
	 * @return Euclidean distance between the nodes
	 */
	public double getDistance(int v1, int v2) {
		throw new UnsupportedOperationException("You need to implement this function!"); 
	}
	
	/**
	 * Finds and returns an optimal shortest tour from the origin node and
	 * returns the order of nodes to visit.
	 * 
	 * Implementation note: Avoid exploring paths which are obviously longer
	 * than the existing shortest tour.
	 * 
	 * @param start Index of the origin node
	 * @return List of nodes to visit in specific order
	 */
	public int[] calculateExactShortestTour(int start){
		throw new UnsupportedOperationException("You need to implement this function!"); 
	}
	
	/**
	 * Returns an optimal shortest tour and returns its distance given the
	 * origin node.
	 * 
	 * @param start Index of the origin node
	 * @return Distance of the optimal shortest TSP tour
	 */
	public double calculateExactShortestTourDistance(int start){
		throw new UnsupportedOperationException("You need to implement this function!"); 
	}	
	
	/**
	 * Returns an approximate shortest tour and returns the order of nodes to
	 * visit given the origin node.
	 * 
	 * Implementation note: Use a greedy nearest neighbor apporach to construct
	 * an initial tour. Then use iterative 2-opt method to improve the
	 * solution.
	 * 
	 * @param start Index of the origin node
	 * @return List of nodes to visit in specific order
	 */
	public int[] calculateApproximateShortestTour(int start){
		throw new UnsupportedOperationException("You need to implement this function!"); 
	}
	
	/**
	 * Returns an approximate shortest tour and returns its distance given the
	 * origin node.
	 * 
	 * @param start Index of the origin node
	 * @return Distance of the approximate shortest TSP tour
	 */
	public double calculateApproximateShortestTourDistance(int start){
		throw new UnsupportedOperationException("You need to implement this function!"); 
	}
	
	/**
	 * Constructs a Hamiltonian cycle by starting at the origin node and each
	 * time adding the closest neighbor to the path.
	 * 
	 * Implementation note: If multiple neighbors share the same distance,
	 * select the one with the smallest id.
	 * 
	 * @param start Origin node
	 * @return List of nodes to visit in specific order
	 */
	public int[] nearestNeighborGreedy(int start){
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * Improves the given route using 2-opt exchange.
	 * 
	 * Implementation note: Repeat the procedure until the route is not
	 * improved in the next iteration anymore.
	 * 
	 * @param route Original route
	 * @return Improved route using 2-opt exchange
	 */
	private int[] twoOptExchange(int[] route) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * Swaps the nodes i and k of the tour and adjusts the tour accordingly.
	 * 
	 * Implementation note: Consider the new order of some nodes due to the
	 * swap!
	 * 
	 * @param route Original tour
	 * @param i Name of the first node
	 * @param k Name of the second node
	 * @return The newly adjusted tour
	 */
	public int[] twoOptSwap(int[] route, int i, int k) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}

	/**
	 * Returns the total distance of the given tour i.e. the sum of distances
	 * of the given path add the distance between the final and initial node.
	 * 
	 * @param tour List of nodes in the given order
	 * @return Travelled distance of the tour
	 */
	public double calculateDistanceTravelled(int[] tour){
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
}
