package psa.naloga1;

import java.util.List;

/**
 * (Unbalanced) Binary Search Tree as a Set, containing integers.
 */
public class BSTSet {
	private BSTSetNode root;
	
	public BSTSet(BSTSetNode root) {
		this.root = root;
	}

	public BSTSet() {
		this.root = null;
	}

	/**
	 * If the element doesn't exist yet, inserts it into the set.
	 * 
	 * @param element Element key
	 * @return true, if element was added; false otherwise.
	 */
	public boolean add(int element) {
		BSTSetNode node = new BSTSetNode(null, null, null, element);
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
	 * @param element Element key
	 * @return true, if the element was removed; otherwise false
	 */
	public boolean remove(int element) {
		if (root == null) {
			return false;
		} else {
			BSTSetNode node = new BSTSetNode(null, null, null, element);
			return root.remove(node);
		}
	}

	/**
	 * Finds the element.
	 * 
	 * @param element Element key
	 * @return true, if the element was found; false otherwise.
	 */
	public boolean contains(int element) {
		if (root == null) {
			return false;
		} else {
			BSTSetNode node = new BSTSetNode(null, null, null, element);
			return root.contains(node);
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
	 * @return List of nodes of preorder traversal
	 */
	public List<Integer> traversePreOrder(){
		return root.traversePreOrder();
	}
	
	/**
	 * Inorder traversal of the tree.
	 * 
	 * @return List of nodes of inorder traversal
	 */
	public List<Integer> traverseInOrder(){
		return root.traverseInOrder();
	}
	
	/**
	 * Postorder traversal of the tree.
	 * 
	 * @return List of nodes of postorder traversal
	 */
	public List<Integer> traversePostOrder(){
		return root.traversePostOrder();
	}
	
	/**
	 * Breadth-first (or level order) traversal of the tree.
	 * 
	 * @return List of nodes of level traversal
	 */
	public List<Integer> traverseLevelOrder(){
		return root.traverseLevelOrder();
	}
}

