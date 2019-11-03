package aps2.shortestpath;

import java.util.*;

public class ShortestPath {

    public HashSet nodes;
    public Graph graph;

    class PathDetails {
        public Vector<String> path;
        public Integer cost;

        PathDetails(Vector<String> path, Integer cost){
            this.path = path;
            this.cost = cost;
        }
    }

    class Path {
        public String source;
        public String destination;
        public Integer cost;

        public Path(String source, String destination, Integer cost){
            this.source = source;
            this.destination = destination;
            this.cost = cost;
        }
    }

    class GraphEdge {
        public String source, destination;
        public int weight;
        public GraphEdge(String source, String destination, int weight) {
            this.source = source;
            this.destination = destination;
            this.weight = weight;
        }
    }

    class Graph {
        public int V, E;
        public ArrayList<GraphEdge> edges;
        public Map<String, Path> distances;
        public boolean hasNegativeCycle;

        public Graph(){
            this.V = this.E = 0;
            this.edges = new ArrayList<>();
            this.distances = new HashMap<>();
            this.hasNegativeCycle = false;
        }
    }

    public ShortestPath() {
        this.graph = new Graph();
        this.nodes = new HashSet();
    }

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

	    if(nodes.contains(s)) {
	        return false;
        }

        this.graph.V += 1;
        nodes.add(s);
        return true;
	}
	
	/**
	 * Returns names of all nodes in the graph.
	 * 
	 * @return Names of all nodes in the graph.
	 */
	public Vector<String> getNodes() {

	    // convert our nodes hashset to vector and return it
	    Vector<String> nodes = new Vector<>();

        Object[] nodesArray = this.nodes.toArray();

	    for(int i = 0; i < nodesArray.length; i++){
	        nodes.add(nodesArray[i].toString());
        }

	    return nodes;
	}
	
	/**
	 * Adds an edge from node a to node b.
	 * 
	 * @param a Source node.
	 * @param b Target node.
	 * @param w Edge weight. Warning: The weight can also be negative!
	 */
	public void addEdge(String a, String b, int w) {
		this.graph.edges.add(new GraphEdge(a, b, w));
		this.graph.E += 1;
	}

	/**
	 * Computes and locally stores shortest paths from the given origin node
	 * to all other nodes in the graph.
	 * 
	 * @param start Origin node.
	 */
	public void computeShortestPaths(String start) {

	    // initialize all values to infinity
	    for(int i = 0; i < this.graph.V; i++){
	        this.graph.distances.put(getNodes().get(i), new Path("", "", Integer.MAX_VALUE));
        }

        // initialize starting point to 0
        this.graph.distances.replace(start, new Path(start, start, 0));

	    // do the Bellman-Ford
	    for(int i = 0; i < this.graph.V; ++i){
	        for(int j = 0; j < this.graph.E; ++j){
	            String u = this.graph.edges.get(j).source;
                String v = this.graph.edges.get(j).destination;
                int weight = this.graph.edges.get(j).weight;

                if(this.graph.distances.get(u).cost != Integer.MAX_VALUE && this.graph.distances.get(u).cost + weight < this.graph.distances.get(v).cost){
                    this.graph.distances.replace(v, new Path(u, v, this.graph.distances.get(u).cost + weight));
                }
            }
        }

        // check for negative cycles
        for(int i = 0; i < this.graph.E; ++i){
            String u = this.graph.edges.get(i).source;
            String v = this.graph.edges.get(i).destination;
            int weight = this.graph.edges.get(i).weight;

            if(this.graph.distances.get(u).cost != Integer.MAX_VALUE && this.graph.distances.get(u).cost + weight < this.graph.distances.get(v).cost){
                this.graph.hasNegativeCycle = true;
                break;
            }
        }
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
        if(this.graph.hasNegativeCycle) return null;
        return getPathDetails(start, dest).path;
	}
	
	/**
	 * Returns the distance of the shortest path from the given origin to
	 * destination node. Returns Integer.MIN_VALUE, if a path does not exist
	 * or there is a negative cycle in the graph.
	 * 
	 * @param start Origin node
	 * @param dest Destination node
	 * @return Distance of the shortest path from start to dest or Integer.MIN_VALUE, if the nodes are not connected or there is a negative cycle in the graph.
	 */
	public int getShortestDist(String start, String dest) {
	    if(this.graph.hasNegativeCycle) return Integer.MIN_VALUE;

        return getPathDetails(start, dest).cost;
	}

	private PathDetails getPathDetails(String start, String dest){

        ArrayList<String> shortestPath = new ArrayList<>();
        Integer cost = 0;

        String source = this.graph.distances.get(dest).source;
        String destination = dest;

        shortestPath.add(dest);
        cost += getCost(source, destination);

        do {
            destination = source;
            source = this.graph.distances.get(destination).source;

            shortestPath.add(0, destination);
            cost += getCost(source, destination);

        } while(start != destination);


        Vector<String> result = new Vector<>();

        for(int i = 0; i < shortestPath.size(); i++){
            result.add(shortestPath.get(i));
        }

        return new PathDetails(result, cost);
    }

	private int getCost(String source, String destination){

	    int cost = 0;

	    for(int i = 0; i < this.graph.edges.size(); i++){
	        GraphEdge edge = this.graph.edges.get(i);

            if(edge.destination == destination && edge.source == source){
                cost = edge.weight;
            }
        }

        return cost;
    }

    // for debugging
    public void printGraph(){
	    System.out.println("V:" + this.graph.V);
        System.out.println("E:" + this.graph.E);

        System.out.println("Edges:");
        for(int i = 0; i < this.graph.edges.size(); i++){
            GraphEdge edge = this.graph.edges.get(i);
            System.out.println("   SRC:" + edge.source + " DEST:" + edge.destination + " W:" + edge.weight);
        }

        System.out.println("Distances:");
        for(int i = 0; i < this.nodes.size(); i++){
            Path path = this.graph.distances.get(this.nodes.toArray()[i]);
            System.out.println("   SRC:" + path.source + " DEST:" + path.destination + " C:" + path.cost);
        }

        System.out.println("HasNegativeCycle:" + this.graph.hasNegativeCycle);
    }
}