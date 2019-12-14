package aps2.bstmap;

import java.util.*;

/**
 * Implementation of the (unbalanced) Binary Search Tree set node.
 */
public class BSTMapNode {
	private static int counter;
	private BSTMapNode left, right, parent;
	private int key;
	private String value;

	public BSTMapNode(BSTMapNode l, BSTMapNode r, BSTMapNode p, int key, String value) {
		super();
		this.left = l;
		this.right = r;
		this.parent = p;
		this.key = key;
		this.value = value;
	}

	public BSTMapNode getLeft() {
		return left;
	}

	public void setLeft(BSTMapNode left) {
		this.left = left;
	}

	public BSTMapNode getRight() {
		return right;
	}

	public void setRight(BSTMapNode right) {
		this.right = right;
	}

	public int getKey() {
		return key;
	}

	public void setKey(int key) {
		this.key = key;
	}
	
	public String getValue() {
		return this.value;
	}
	
	public void setValue(String value) {
		this.value = value;
	}

	public int compare(BSTMapNode node) {
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
	 * @param element Given key/value wrapped inside an empty BSTNode instance
	 * @return true, if the element was added; false otherwise.
	 */
	public boolean add(BSTMapNode element) {

		if(element.getKey() == this.getKey())
			return false;

		else if(this.getKey() > element.getKey()){
			if(left == null) {
				left = new BSTMapNode(null, null, this, element.getKey(), element.getValue());
				return true;
			} else
				return left.add(element);
		} else if (this.getKey() < element.getKey()) {
			if(right == null){
				right = new BSTMapNode(null, null, this, element.getKey(), element.getValue());
				return true;
			} else
				return right.add(element);
		}
		return false;
	}
	
	/**
	 * Finds and removes the element with the given key from the subtree.
	 * 
	 * @param element Given key wrapped inside an empty BSTNode instance
	 * @return true, if the element was found and removed; false otherwise.
	 */
	public boolean remove(BSTMapNode element) {

		if(this.getKey() > element.getKey())
			return getLeft() != null ? getLeft().remove(element) : false;

		else if(this.getKey() < element.getKey())
			return getRight() != null ? getRight().remove(element) : false;

		else {
			if(getLeft() != null && getRight() != null){
				this.setKey(getRight().findMin().getKey());
				getRight().remove(element);
			} else if(parent.getLeft() == this) {
				BSTMapNode x = getLeft()!= null ? getLeft() : getRight();
				parent.setLeft(x);
			} else if(parent.getRight() == this) {
				BSTMapNode x = getLeft() != null ? getLeft() : getRight();
				parent.setRight(x);
			}
			return true;
		}
	}

	/**
	 * Checks whether the element with the given key exists in the subtree.
	 * 
	 * @param element Query key wrapped inside an empty BSTNode instance
	 * @return true, if an element with the given key is contained in the subtree; false otherwise.
	 */
	public boolean contains(BSTMapNode element) {
		counter++;
		if(this.getKey() == element.getKey())
			return true;

		else if (this.getKey() > element.getKey())
			return left == null ? false : left.contains(element);

		else if(this.getKey() < element.getKey())
			return right == null ? false : right.contains(element);

		return false;
	}

	/**
	 * Maps the given key to its value.
	 * 
	 * @param element Query key wrapped inside an empty BSTNode instance
	 * @return String value of the given key; null, if an element with the given key does not exist in the subtree.
	 */
	public String get(BSTMapNode element) {

		if(this.getKey() == element.getKey())
			return this.getValue();

		else if (this.getKey() > element.getKey())
			return left == null ? null : left.get(element);

		else if(this.getKey() < element.getKey())
			return right == null ? null : right.get(element);

		return null;
	}

	/**
	 * Finds the smallest element in the subtree.
	 * 
	 * @return Smallest element in the subtree
	 */
	public BSTMapNode findMin() {
		return left == null ? this : left.findMin();
	}
	
	/**
	 * Depth-first pre-order traversal of the BST.
	 * 
	 * @return List of keys stored in BST obtained by pre-order traversing the tree.
	 */
	List<Integer> traversePreOrder() {
		List<Integer> list = new ArrayList();

		if(this == null)
			return list;

		Stack<BSTMapNode> stack = new Stack();
		stack.push(this);

		while(!stack.isEmpty())
		{
			BSTMapNode n = stack.pop();
			list.add(n.getKey());

			if(n.right != null)
				stack.push(n.right);
			if(n.left != null)
				stack.push(n.left);
		}
		return list;
	}

	/**
	 * Depth-first in-order traversal of the BST.
	 * 
	 * @return List of keys stored in BST obtained by in-order traversing the tree.
	 */
	List<Integer> traverseInOrder() {
		List<Integer> list = new ArrayList();

		if(this == null)
			return list;

		Stack<BSTMapNode> stack = new Stack();
		BSTMapNode node = this;

		while(!stack.isEmpty() || node != null) {
			if(node != null) {
				stack.push(node);
				node = node.left;
			}
			else {
				BSTMapNode tmpNode = stack.pop();
				list.add(tmpNode.getKey());
				node = tmpNode.right;
			}
		}
		return list;
	}

	/**
	 * Depth-first post-order traversal of the BST.
	 * 
	 * @return List of keys stored in BST obtained by post-order traversing the tree.
	 */
	List<Integer> traversePostOrder() {

		List<Integer> list = new ArrayList();

		if(this == null)
			return list;

		Stack<BSTMapNode> stack = new Stack();
		BSTMapNode node = this;

		while(true){
			if(node != null){
				if(node.right != null) {
					stack.push(node.right);
				}
				stack.push(node);
				node = node.left;
				continue;
			}

			if(stack.isEmpty())
				return list;
			node = stack.pop();

			if(node.right != null && !stack.isEmpty() && node.right == stack.peek()) {
				stack.pop();
				stack.push(node);
				node = node.right;
			}
			else {
				list.add(node.getKey());
				node = null;
			}
		}
	}

	/**
	 * Breadth-first (or level-order) traversal of the BST.
	 * 
	 * @return List of keys stored in BST obtained by breadth-first traversal of the tree.
	 */
	List<Integer> traverseLevelOrder() {
		List<Integer> list = new ArrayList();
		Queue<BSTMapNode> queue = new LinkedList<>();

		if(this == null)
			return list;

		queue.add(this);
		while(!queue.isEmpty()) {
			BSTMapNode node = queue.poll();
			list.add(node.getKey());
			if(node.left != null)
				queue.add(node.left);
			if(node.right != null)
				queue.add(node.right);

		}

		return list;
	}
}
