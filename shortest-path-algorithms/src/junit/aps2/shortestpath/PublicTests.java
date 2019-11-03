package aps2.shortestpath;

import java.util.HashSet;
import java.util.Iterator;
import java.util.Random;
import java.util.Vector;

import aps2.shortestpath.ShortestPath;
import junit.framework.TestCase;

public class PublicTests extends TestCase {
	private Vector<String> allTowns;
	private Random r;
	private static String[] suffixes = { "grad", "burg", "ton", "ek" };

	private static String[] prequalifiers = {"gornji", "doljni", "srednji", "nagy", "kis", "ober", "unter"};

	private static String[] roots = {"kraven", "boler", "koenig", "pasji", "maczka", "kirchen", "senov", "bistrin", "drenov",
		"raven", "poden", "wegen", "lisen", "kirgen", "krulen", "mulen", "tulen", "bulen", "peter", "pavel", "ekaterin"};

	protected void setUp() throws Exception {
		allTowns = new Vector<String>();

		for (String suffix:suffixes){
			for (String root:roots){
				allTowns.add(root + suffix);
			}
		}
		for (String prequalifier:prequalifiers){
			for (String suffix:suffixes){
				for (String root:roots){
					allTowns.add(prequalifier + " " + root + suffix);
				}
			}
		}

		r = new Random(31337);
	}
	private void fillGraphUndirected(ShortestPath g, int npoints, int ncrosslinks, Random r){
		for (int i = 0; i < npoints; i++){
			assertTrue(g.addNode(allTowns.get(i)));
		}
		Vector<String> t = g.getNodes();
		int a, b, w;
		int i;

		// System.out.print("\n\nt.size:" + " " +  t.size() + "\n");

		for (i = 1; i < t.size(); i++){
			a = r.nextInt(i);
			w = r.nextInt(10)+1;
			g.addEdge(t.get(i), t.get(a), w);
			g.addEdge(t.get(a), t.get(i), w);
		}
		for (i = 0; npoints > 1 && i < ncrosslinks; i++){
			a = r.nextInt(npoints-1)+1;
			b = r.nextInt(a);
			w = r.nextInt(10)+1;

			//System.out.print("a:" + a + " "+ "b:" + b + " " + "w:" + w + "\n");

			g.addEdge(t.get(a), t.get(b), w);
			g.addEdge(t.get(b), t.get(a), w);
		}
/*
        for(int j = 0; j < g.graph.edges.size(); j++) {
            System.out.println("\n\nEdge:");
            System.out.print(g.graph.edges.get(j).source + " ");
            System.out.print(g.graph.edges.get(j).destination + " ");
            System.out.print(g.graph.edges.get(j).weight);
        }
        System.out.println("\n\nsize: " + g.graph.edges.size());
        */
	}
	
	public void testSimpleAdd() throws Exception {
		ShortestPath g = new ShortestPath();
		for (int i = 0; i < 10; i++){
			assertTrue(g.addNode(allTowns.get(i)));
		}
		for (int i = 5; i < 10; i++){
			assertFalse(g.addNode(allTowns.get(i)));
		}
		for (int i = 10; i < 15; i++){
			assertTrue(g.addNode(allTowns.get(i)));
		}
	}

	public void testGetNodes() throws Exception {
        ShortestPath g = new ShortestPath();
        for (int i = 0; i < 10; i++){
            assertTrue(g.addNode(allTowns.get(i)));
        }

        Object[] allTownsArray = allTowns.toArray();
        Object[] nodesArray = g.getNodes().toArray();

        HashSet allTownsHashSet = new HashSet<String>();
        HashSet nodesHashSet = new HashSet<String>();

        for(int i = 0; i < 10; i++){
            allTownsHashSet.add(allTownsArray[i].toString());
        }

        for(int i = 0; i < nodesArray.length; i++){
            nodesHashSet.add(nodesArray[i].toString());
        }

        assertEquals(allTownsHashSet, nodesHashSet);
    }

    public void testAddEdge() throws Exception {

        ShortestPath g = new ShortestPath();

        fillGraphUndirected(g, 5, 3, r);

    }

	public void testNeighbors() throws Exception {
		ShortestPath g = new ShortestPath();
		r.setSeed(64);
		fillGraphUndirected(g, 5, 3, r);

        // g.printGraph();

		//System.out.print("E:" + g.graph.E + " V:" + g.graph.V);

		final Integer[][] dists = {
			{ 0,  7,  9, null, null},
			{ 7,  0, null,  3,  8},
			{ 9, null,  0, null,  2},
			{null,  3, null,  0, null},
			{null,  8,  2, null,  0}};

		Vector<String> towns = g.getNodes();

		for (int i = 0; i < 5; i++){
			g.computeShortestPaths(towns.elementAt(i));
			for (int j = 0; j < 5; j++){
				if (dists[i][j] != null){
					assertEquals((int)dists[i][j], g.getShortestDist(towns.elementAt(i), towns.elementAt(j)));
				}
			}
		}
	}
	
	public void testDistToFewTownsUndirected() throws Exception {
		ShortestPath g = new ShortestPath();
		fillGraphUndirected(g, 10, 15, r);
		Vector<String> towns = g.getNodes();
		g.computeShortestPaths(towns.get(0));

		g.printGraph();

		assertEquals(g.getShortestDist(towns.get(0), towns.get(3)), 1);
		assertEquals(g.getShortestDist(towns.get(0), towns.get(4)), 5);
		assertEquals(g.getShortestDist(towns.get(0), towns.get(5)), 13);
		assertEquals(g.getShortestDist(towns.get(0), towns.get(4)), 5);
	}
	
	public void testDistToEachTownUndirected() throws Exception {
		ShortestPath g = new ShortestPath();
		r.setSeed(35);
		fillGraphUndirected(g, 5, 1, r);
		final int[][] dists = {
			{0,  8,  6,  8, 13},
			{8,  0, 14, 16,  2},
			{6, 14,  0,  8,  9},
			{8, 16,  8,  0, 10},
			{13, 2,  9, 10,  0}};
		Vector<String> towns = new Vector<String>(g.getNodes());
		for (int i = 0; i < 5; i++){
			g.computeShortestPaths(towns.elementAt(i));
			for (int j = 0; j < 5-i; j++){
				assertEquals(dists[i][j], g.getShortestDist(towns.elementAt(i), towns.elementAt(j)));
			}
		}
	}
	public void testPathToTownUndirected() throws Exception {
		ShortestPath g = new ShortestPath();
		r.setSeed(25);
		fillGraphUndirected(g, 10, 2, r);
		Iterator<String>si = g.getNodes().iterator();
		String start = "drenovgrad";
		String dest = "ravengrad";
		while(si.hasNext()){
			dest = si.next();
		}
		final String[] path = {"drenovgrad", "koeniggrad", "kravengrad", "bolergrad", "pasjigrad", "bistringrad", "ravengrad"};
		int i = 0;
		g.computeShortestPaths(start);
		for (String s:g.getShortestPath(start, dest)){
			assertEquals(s, path[i]);
			i++;
		}
	}
}
