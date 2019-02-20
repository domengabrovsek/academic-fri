package psa.naloga0;

import junit.framework.TestCase;

/**
 * Add Public Tests to this class. Public tests are written by the Instructor
 * and may be used for grading projects. This source code is made available to
 * students.
 */
public class PublicTests extends TestCase {
	Naloga naloga;

	protected void setUp() throws Exception {
		naloga = new Naloga();
	}
	
	public void testObrniNiz() {
		assertEquals("tset", naloga.obrniNiz("test"));
	}
	
	public void testObrniNizPrazen() {
		assertEquals("", naloga.obrniNiz(""));
	}
	
	public void testObrniNizNull() {
		assertEquals(null, naloga.obrniNiz(null));
	}

	public void testVrniNajvecjega() {
		int[] polje = { 1, 1, 2, 6, 24, 120, 720, 5040 };
		int rezultat = naloga.najdiNajvecjega(polje);
		assertEquals(5040, rezultat);
	}
}