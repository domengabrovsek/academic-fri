package aps2.patricia;

import junit.framework.TestCase;

/**
 * insert Public Tests to this class. Public tests are written by the Instructor
 * and may be used for grading projects. This source code is made available to
 * students.
 */

public class PublicTests extends TestCase {
	protected void setUp() throws Exception {
	}
	
	public void testPatriciaSetNode() throws Exception {
		PatriciaSetNode root = new PatriciaSetNode("", false);
		PatriciaSetNode abc = new PatriciaSetNode("ABC", true);
		PatriciaSetNode def = new PatriciaSetNode("DEF", true);
		PatriciaSetNode ghi = new PatriciaSetNode("GHI", true);
		PatriciaSetNode abc2 = new PatriciaSetNode("ABC2", true);
		
		assertEquals(true, root.addChild(ghi));
		assertEquals(true, root.addChild(abc));
		assertEquals(true, root.addChild(def));
		assertEquals(false, root.addChild(abc2)); // child in direction of A already exists!
		
		assertEquals(3, root.countChildren());
		
		assertEquals(abc, root.getChild('A'));
		assertEquals(def, root.getChild('D'));
		assertEquals(ghi, root.getChild('G'));
		
		assertEquals(abc, root.firstChild); // children should be ordered
		assertEquals(def, root.firstChild.nextSibling);
		assertEquals(ghi, root.firstChild.nextSibling.nextSibling);
		
		assertEquals(root, abc.getParent());
		assertEquals(root, def.getParent());
		assertEquals(root, ghi.getParent());
		
		assertEquals(true, root.removeChild('G'));
		assertEquals(false, root.removeChild('H')); // child in direction of H doesn't exist!
	}
	
	public void testPatriciaSetInsertion() throws Exception { 
		PatriciaSet p = new PatriciaSet();
		assertEquals(true, p.insert("TEST"));
		assertEquals(true, p.insert("TEST2"));
		assertEquals(true, p.insert("TEMPO"));
		assertEquals(true, p.insert("TAMPO"));
		assertEquals(false, p.insert("TEST")); // duplicate
		
		assertEquals("T", p.getRoot().firstChild.getLabel());
		assertEquals("AMPO", p.getRoot().firstChild.firstChild.getLabel());
		assertEquals("E", p.getRoot().firstChild.firstChild.nextSibling.getLabel());
		assertEquals("MPO", p.getRoot().firstChild.firstChild.nextSibling.firstChild.getLabel());
	}
	
	public void testPatriciaSetFind() throws Exception { 
		PatriciaSet p = new PatriciaSet();
		p.insert("TEST");
		p.insert("TEST2");
		p.insert("TEMPO");
		p.insert("TAMPO");
		p.insert("TARPO");
		p.insert("TE");
		
		assertEquals(true, p.contains("TEST"));
		assertEquals(false, p.contains("TES"));
		assertEquals(true, p.contains("TE"));
		assertEquals(false, p.contains("TEST3"));
		assertEquals(false, p.contains("TESR"));
		assertEquals(false, p.contains("TAR"));
	}
	
	public void testPatriciaInsertAllSuffixes() throws Exception {
		String text = "ABRACADABRA";
		PatriciaSet p = new PatriciaSet();
		for (int i=0; i<text.length(); i++) {
			assertEquals(true, p.insert(text.substring(i)));
		}
		
		for (int i=0; i<text.length(); i++) {
			assertEquals(true, p.contains(text.substring(i)));
		}
	}
}
