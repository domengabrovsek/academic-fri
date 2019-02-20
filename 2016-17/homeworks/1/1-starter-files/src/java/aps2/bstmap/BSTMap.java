package aps2.bstmap;

import java.util.List;

/**
 * (Unbalanced) Binary Search Tree for mapping integer -> string.
 */
public class BSTMap {
	private BSTMapNode root;
	
	public BSTMap(BSTMapNode root) {
		this.root = root;
	}

	public BSTMap() {
		this.root = null;
	}

	// check if tree is empty
	public boolean isEmpty()
	{
		return root == null;
	}

	/**
	 * If the element doesn't exist yet, inserts it into the set.
	 * 
	 * @param key Element key
	 * @param value Element value
	 * @return true, if element was added; false otherwise.
	 */
	public boolean add(int key, String value) {
		BSTMapNode node = new BSTMapNode(null, null, null, key, value);
		if (root == null) {
			this.root = node;
			return true;
		} else {
			return root.add(node);
		}
	}

	/**
	 * Removes the element from the set.
	 * 
	 * @param key Element key
	 * @return true, if the element was removed; otherwise false
	 */
	public boolean remove(int key) {
		if (root == null) {
			return false;
		} else {
			BSTMapNode node = new BSTMapNode(null, null, null, key, null);
			return root.remove(node);
		}
	}

	/**
	 * Finds the element.
	 * 
	 * @param element Element key
	 * @return true, if the element was found; false otherwise.
	 */
	public boolean contains(int key) {
		if (root == null) {
			return false;
		} else {
			BSTMapNode node = new BSTMapNode(null, null, null, key, null);
			return root.contains(node);
		}
	}
	
	/**
	 * Maps the given key to its value.
	 * 
	 * @param key Element key
	 * @return String value of the given key; null, if an element with the given key does not exist in the subtree.
	 */
	public String get(int key) {
		if (root == null) {
			return null;
		} else {
			BSTMapNode node = new BSTMapNode(null, null, null, key, null);
			return root.get(node);
		}
	}
	
	public int getCounter() {
		return root != null?root.getCounter():null;
	}
	
	public void resetCounter() {
		if(root!= null)
			root.resetCounter();
	}
	
	/**
	 * Preorder traversal of the tree.
	 * 
	 * @return List of node keys in preorder traversal
	 */
	public List<Integer> traversePreOrder(){
		return root.traversePreOrder();
	}
	
	/**
	 * Inorder traversal of the tree.
	 * 
	 * @return List of node keys in preorder traversal
	 */
	public List<Integer> traverseInOrder(){
		return root.traverseInOrder();
	}
	
	/**
	 * Postorder traversal of the tree.
	 * 
	 * @return List of node keys in preorder traversal
	 */
	public List<Integer> traversePostOrder(){
		return root.traversePostOrder();
	}
	
	/**
	 * Breadth-first (or level order) traversal of the tree.
	 * 
	 * @return List of node keys in preorder traversal
	 */
	public List<Integer> traverseLevelOrder(){
		return root.traverseLevelOrder();
	}
}

