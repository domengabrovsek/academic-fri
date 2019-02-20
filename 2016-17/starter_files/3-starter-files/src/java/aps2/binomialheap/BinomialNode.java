package aps2.binomialheap;

import java.util.Vector;

public class BinomialNode {
	private Vector<BinomialNode> children;
	private int key;
	
	public BinomialNode(int key) {
		this.key = key;
		children = new Vector<BinomialNode>();
	}
	
	public int getDegree() {
		return children.size();
	}
	
	public boolean addChild(BinomialNode child) {
		return children.add(child);
	}
	
	public Vector<BinomialNode> getChildren() {
		return this.children;
	}
	
	public int getKey() {
		return this.key;
	}
	
	public int compare(BinomialNode node) {
		if (node.key < this.key) 
			return -1;
		if (node.key > this.key)
			return 1;
		return 0;
	}
}
