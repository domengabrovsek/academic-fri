package aps2.tsp;

import java.util.Random;

import aps2.tsp.TravellingSalesman;
import junit.framework.TestCase;

public class PublicTests extends TestCase {
	private Random r;
	private TravellingSalesman ts;
	
	protected void setUp() {
		ts = new TravellingSalesman();
	}
	
	public void testAddVertex() {
		r = new Random(1640);
		
		for (int i = 0; i < 10; i++) {
			ts.addNode(r.nextInt(50), r.nextInt(50));
		}
	
		double[][] pairDistances = {{0.0, 12.649110640673518, 13.601470508735444, 29.154759474226502, 14.422205101855956, 37.21558813185679, 34.713109915419565, 35.4682957019364, 7.0710678118654755, 12.206555615733702},
				{12.649110640673518, 0.0, 4.123105625617661, 18.384776310850235, 26.832815729997478, 33.95585369269929, 23.600847442411894, 29.017236257093817, 17.029386365926403, 11.180339887498949},
				{13.601470508735444, 4.123105625617661, 0.0, 21.095023109728988, 28.0178514522438, 29.832867780352597, 21.213203435596427, 25.079872407968907, 19.209372712298546, 15.033296378372908},
				{29.154759474226502, 18.384776310850235, 21.095023109728988, 0.0, 41.30375285612676, 47.16990566028302, 26.1725046566048, 39.395431207184416, 30.265491900843113, 19.4164878389476},
				{14.422205101855956, 26.832815729997478, 28.0178514522438, 41.30375285612676, 0.0, 47.75981574503821, 49.040799340956916, 48.02082881417188, 11.045361017187261, 22.02271554554524},
				{37.21558813185679, 33.95585369269929, 29.832867780352597, 47.16990566028302, 47.75981574503821, 0.0, 26.076809620810597, 9.848857801796104, 44.28317965096906, 44.40720662234904},
				{34.713109915419565, 23.600847442411894, 21.213203435596427, 26.1725046566048, 49.040799340956916, 26.076809620810597, 0.0, 16.401219466856727, 40.36087214122113, 34.0},
				{35.4682957019364, 29.017236257093817, 25.079872407968907, 39.395431207184416, 48.02082881417188, 9.848857801796104, 16.401219466856727, 0.0, 42.37924020083418, 40.11234224026316},
				{7.0710678118654755, 17.029386365926403, 19.209372712298546, 30.265491900843113, 11.045361017187261, 44.28317965096906, 40.36087214122113, 42.37924020083418, 0.0, 11.0},
				{12.206555615733702, 11.180339887498949, 15.033296378372908, 19.4164878389476, 22.02271554554524, 44.40720662234904, 34.0, 40.11234224026316, 11.0, 0.0}};

		for (int i = 0; i < pairDistances.length; i++) {
			for (int j = 0; j < pairDistances.length; j++) {
				assertEquals(pairDistances[i][j], ts.getDistance(i, j), 1.0E-9);
			}
		}
	}
	
	public void testDistanceTravelledOnPath() {
		r = new Random(1640);
		
		for (int i = 0; i < 10; i++) {
			ts.addNode(r.nextInt(50), r.nextInt(50));
		}
		
		int[][] verticesOnPath = {{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}, 
								  {1, 2, 3, 4, 5, 6, 7, 8, 9, 0}, 
								  {2, 3, 4, 5, 6, 7, 8, 9, 0, 1}, 
								  {4, 0, 1, 2, 7, 6, 3, 5, 9, 8},
								  {0, 8, 9, 1, 2, 3, 6, 7, 5, 4}, 
							      {4, 5, 7, 9, 3, 2, 1, 6, 0, 8}, 
								  {4, 0, 5, 7, 6, 3, 2, 1, 9, 8}};
		
		double[] pathLengths = {234.99463288142036, 234.99463288142036, 234.99463288142036, 212.4704911993969, 169.07413920686287, 218.78601854827593, 162.50420479900325};
		
		for (int i = 0; i < verticesOnPath.length; i++) {
			assertEquals(pathLengths[i], ts.calculateDistanceTravelled(verticesOnPath[i]), 1.0E-6);
		}
	}

	public void testNearestNeighbourGreedy(){
		
		r = new Random(35164);
		
		for (int i = 0; i < 10; i++) {
			ts.addNode(r.nextInt(50), r.nextInt(50));
		}
		
		int[][] expectedRoutes = {{0, 5, 2, 8, 4, 6, 3, 7, 9, 1},
								{4, 8, 2, 1, 6, 3, 7, 9, 0, 5}};
		
		int[] route = ts.nearestNeighborGreedy(0);
		for (int i = 0; i < expectedRoutes[0].length; i++) {
			assertEquals(expectedRoutes[0][i], route[i]);
		}
		assertEquals(154.5833713264122, ts.calculateDistanceTravelled(route), 1.0E-6);

		route = ts.nearestNeighborGreedy(4);
		for (int i = 0; i < expectedRoutes[1].length; i++) {
			assertEquals(expectedRoutes[1][i], route[i]);
		}
		assertEquals(139.27354642544432, ts.calculateDistanceTravelled(route), 1.0E-6);
		
	}
	
	public void test2OptSwap(){
		
		int[] route = {10, 4, 8, 2, 5, 0, 9, 7, 3, 6, 1};
		
		int[][] modifiedRoutes = {{10, 4, 8, 9, 0, 5, 2, 7, 3, 6, 1},
								 {10, 4, 8, 2, 5, 0, 9, 7, 6, 3, 1},
								 {0, 5, 2, 8, 4, 10, 9, 7, 3, 6, 1}};
		
		int[] swappedRoute = ts.twoOptSwap(route, 3, 6);
		for (int i = 0; i < modifiedRoutes[0].length; i++) {
			assertEquals(modifiedRoutes[0][i], swappedRoute[i]);
		}
		
		swappedRoute = ts.twoOptSwap(route, 8, 9);
		for (int i = 0; i < modifiedRoutes[1].length; i++) {
			assertEquals(modifiedRoutes[1][i], swappedRoute[i]);
		}
		
		swappedRoute = ts.twoOptSwap(route, 0, 5);
		for (int i = 0; i < modifiedRoutes[2].length; i++) {
			assertEquals(modifiedRoutes[2][i], swappedRoute[i]);
		}
	}
	
	public void testShortestRoute(){
		r = new Random(35164);
		
		for (int i = 0; i < 12; i++) {
			ts.addNode(r.nextInt(50), r.nextInt(50));
		}
		
		assertEquals(129.8921730786234, ts.calculateExactShortestTourDistance(0), 1.0E-6);
		assertEquals(129.8921730786234, ts.calculateDistanceTravelled(ts.calculateExactShortestTour(0)), 1.0E-6);
		
		ts.addNode(r.nextInt(50), r.nextInt(50));
		assertEquals(130.62668614179347, ts.calculateExactShortestTourDistance(0), 1.0E-6);
		assertEquals(130.62668614179347, ts.calculateDistanceTravelled(ts.calculateExactShortestTour(0)), 1.0E-6);
		
	}
	
}
