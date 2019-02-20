package psa.naloga1;

import java.util.LinkedList;
import java.util.List;

/**
 * Implementation of the (unbalanced) Binary Search Tree set node.
 */
public class BSTSetNode {
	private static int counter;
	private BSTSetNode left, right, parent;
	private int key;

	public BSTSetNode(BSTSetNode l, BSTSetNode r, BSTSetNode p,
			int key) {
		super();
		this.left = l;
		this.right = r;
		this.parent = p;
		this.key = key;
	}

	public BSTSetNode getLeft() {
		return left;
	}

	public void setLeft(BSTSetNode left) {
		this.left = left;
	}

	public BSTSetNode getRight() {
		return right;
	}

	public void setRight(BSTSetNode right) {
		this.right = right;
	}

	public int getKey() {
		return key;
	}

	public void setKey(int key) {
		this.key = key;
	}

	public int compare(BSTSetNode node) {
		counter++;
		return node.key-this.key;
	}

	public int getCounter() {
		return counter;
	}

	public void resetCounter() {
		counter = 0;
	}

	/**
	 * If the element doesn't exist yet, adds the given element to the subtree.
	 * 
	 * @param element Given key wrapped inside an empty BSTNode instance
	 * @return true, if the element was added; false otherwise.
	 */
	public boolean add(BSTSetNode element) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * Finds and removes the element with the given key from the subtree.
	 * 
	 * @param element Given key wrapped inside an empty BSTNode instance
	 * @return true, if the element was found and removed; false otherwise.
	 */
	public boolean remove(BSTSetNode element) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}

	/**
	 * Checks whether the element with the given key exists in the subtree.
	 * 
	 * @param element Query key wrapped inside an empty BSTNode instance
	 * @return true, if the element is contained in the subtree; false otherwise.
	 */
	public boolean contains(BSTSetNode element) {
		throw new UnsupportedOperationException("You need to implement this function!");
	}

	/**
	 * Finds the smallest element in the subtree.
	 * This function is in some cases used during
	 * the removal of the element.
	 * 
	 * @return Smallest element in the subtree
	 */
	public BSTSetNode findMin() {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
	
	/**
	 * Depth-first pre-order traversal of the BST.
	 * 
	 * @return List of elements stored in BST obtained by pre-order traversing the tree.
	 */
	List<Integer> traversePreOrder() {
		throw new UnsupportedOperationException("You need to implement this function!");
	}

	/**
	 * Depth-first in-order traversal of the BST.
	 * 
	 * @return List of elements stored in BST obtained by in-order traversing the tree.
	 */
	List<Integer> traverseInOrder() {
		throw new UnsupportedOperationException("You need to implement this function!");
	}

	/**
	 * Depth-first post-order traversal of the BST.
	 * 
	 * @return List of elements stored in BST obtained by post-order traversing the tree.
	 */
	List<Integer> traversePostOrder() {
		throw new UnsupportedOperationException("You need to implement this function!");
	}

	/**
	 * Breadth-first (or level-order) traversal of the BST.
	 * 
	 * @return List of elements stored in BST obtained by breadth-first traversal of the tree.
	 */
	List<Integer> traverseLevelOrder() {
		throw new UnsupportedOperationException("You need to implement this function!");
	}
}
