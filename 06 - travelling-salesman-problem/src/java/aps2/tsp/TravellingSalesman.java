package aps2.tsp;

import sun.reflect.generics.reflectiveObjects.NotImplementedException;

import java.util.ArrayList;

public class TravellingSalesman {

    private ArrayList<Element> elements = new ArrayList<>();

    class Element {
        private int x,y;

        Element(int x, int y) {
            this.x = x;
            this.y = y;
        }
    }

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
        this.elements.add(new Element(x, y));
	}
	
	/**
	 * Returns the distance between nodes v1 and v2.
	 * 
	 * @param v1 Identifier of the first node
	 * @param v2 Identifier of the second node
	 * @return Euclidean distance between the nodes
	 */
	public double getDistance(int v1, int v2) {
        return Math.sqrt(Math.pow(this.elements.get(v1).x - this.elements.get(v2).x, 2) + Math.pow(this.elements.get(v1).y - this.elements.get(v2).y, 2));
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
        int[] route = nearestNeighborGreedy(start);
        ArrayList<Integer> stack = new ArrayList<>();
        for (int i = route.length - 1; i >= 0; i--) {
            stack.add(route[i]);
        }

        return backTrack(route, new ArrayList<>(), stack, calculateDistanceTravelled(route), 0, start);
	}
	
	/**
	 * Returns an optimal shortest tour and returns its distance given the
	 * origin node.
	 * 
	 * @param start Index of the origin node
	 * @return Distance of the optimal shortest TSP tour
	 */
	public double calculateExactShortestTourDistance(int start){
        int r[] = calculateExactShortestTour(start);
        return calculateDistanceTravelled(r);
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
        throw new NotImplementedException();
	}
	
	/**
	 * Returns an approximate shortest tour and returns its distance given the
	 * origin node.
	 * 
	 * @param start Index of the origin node
	 * @return Distance of the approximate shortest TSP tour
	 */
	public double calculateApproximateShortestTourDistance(int start){
        throw new NotImplementedException();
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
        int[] path = new int[this.elements.size()];
        ArrayList<Integer> already = new ArrayList<>();
        int k = 0;
        path[k] = start;
        already.add(start);
        for (int i = 0; i < this.elements.size() - 1; i++) {
            double min = Integer.MAX_VALUE;
            int pos = -1;
            for (int j = 0; j < this.elements.size(); j++) {
                if (already.contains(j)){
                    continue;
                }

                double dis = getDistance(start, j);
                if (min > dis) {
                    min = dis;
                    pos = j;
                }
            }
            start = pos;
            k++;
            path[k] = start;
            already.add(start);
        }

        return path;
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
        throw new NotImplementedException();
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
        int[] r = route.clone();
        while (i < k) {
            int tmp = r[k];
            r[k] = r[i];
            r[i] = tmp;
            i++;
            k--;
        }
        return r;
	}

	/**
	 * Returns the total distance of the given tour i.e. the sum of distances
	 * of the given path add the distance between the final and initial node.
	 * 
	 * @param tour List of nodes in the given order
	 * @return Travelled distance of the tour
	 */
	public double calculateDistanceTravelled(int[] tour){
        double path = 0;
        for (int i = 0; i < tour.length - 1; i++) {
            path += getDistance(tour[i], tour[i + 1]);
        }
        return path + getDistance(tour[0], tour[tour.length - 1]);
	}

    private int[] backTrack(int[] current, ArrayList<Integer> path, ArrayList<Integer> queue, double currentDistance, int depth, int start) {
	    int pathSize = path.size();

        if (queue.isEmpty()){
            double dist = 0;

            if (pathSize >= 2){
                int[] r = new int[path.size()];
                for (int i = 0; i < r.length; i++){
                    r[i] = path.get(i);
                }
                dist = calculateDistanceTravelled(r);
            }

            if (calculateDistanceTravelled(current) > dist){
                for (int i = 0; i < path.size(); i++){
                    current[i] = path.get(i);
                }
            }

            return current;
        }

        int check = 1;
        int a = queue.get(0);
        while (!queue.isEmpty() && (a != queue.get(0) || check == 1)){
            int node = queue.remove(queue.size()-1);
            if (depth == 0 && node != start) {
                return current;
            }

            path.add(node);
            double d = 0;

            if(pathSize >= 2){
                int[] r = new int[pathSize];
                for (int i = 0; i < r.length; i++){
                    r[i] = path.get(i);
                }
                d = calculateDistanceTravelled(r);
            }

            if (d <= currentDistance){
                ArrayList<Integer> cl;
                cl = (ArrayList<Integer>) queue.clone();

                ArrayList<Integer> cl2;
                cl2 = (ArrayList<Integer>) path.clone();

                current =  backTrack(current, cl2, cl, currentDistance,depth + 1, start);
                currentDistance = calculateDistanceTravelled(current);

                int tmp = path.remove(path.size()-1);
                queue.add(0, tmp);
            }
            else {
                int tmp = path.remove(path.size()-1);
                queue.add(0, tmp);
            }
            check += 1;
        }
        return current;
    }
}