package aps2.shortestpath;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

public class ShortestPath {
	/**
	 * In this task you need to find a shortest path on a given directed graph
	 * with arbitrary edge lengths (including negative weights!) from a single
	 * source node to all other nodes in the graph.
	 * 
	 * Your algorithm should also detect, if there is a negative cycle in the
	 * graph and return null in this case.
	 */
			
	/**
	 * Adds a new node named s to the graph.
	 * 
	 * @param s Name of the node
	 * @return True, if a node is unique and successfully added; False otherwise.
	 */
	public boolean addNode(String s) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * Returns names of all nodes in the graph.
	 * 
	 * @return Names of all nodes in the graph.
	 */
	public Vector<String> getNodes() {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * Adds an edge from node a to node b.
	 * 
	 * @param a Source node.
	 * @param b Target node.
	 * @param w Edge weight. Warning: The weight can also be negative!
	 */
	public void addEdge(String a, String b, int w) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}

	/**
	 * Computes and locally stores shortest paths from the given origin node
	 * to all other nodes in the graph.
	 * 
	 * @param start Origin node.
	 */
	public void computeShortestPaths(String start) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * Returns a list of nodes on the shortest path from the given origin to
	 * destination node. Returns null, if a path does not exist or there is a
	 * negative cycle in the graph.
	 * 
	 * @param start Origin node
	 * @param dest Destination node
	 * @return List of nodes on the shortest path from start to dest or null, if the nodes are not connected or there is a negative cycle in the graph.
	 */
	public Vector<String> getShortestPath(String start, String dest) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * Returns the distance of the shortest path from the given origin to
	 * destination node. Returns Integer.MIN_VALUE, if a path does not exist
	 * or there is a negative cycle in the graph.
	 * 
	 * @param start Origin node
	 * @param dest Destination node
	 * @return Distance of the shortest path from start to dest, Integer.MIN_VALUE, if there is a negative cycle in the graph, or Integer.MAX_VALUE, if the nodes are not connected.
	 */
	public int getShortestDist(String start, String dest) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
}
