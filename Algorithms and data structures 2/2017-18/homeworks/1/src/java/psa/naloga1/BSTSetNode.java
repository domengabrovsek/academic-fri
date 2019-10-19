package psa.naloga1;

import java.util.*;

/**
 * Implementation of the (unbalanced) Binary Search Tree set node.
 */
public class BSTSetNode {
	private static int counter;
	private BSTSetNode left, right, parent;
	private int key;

	public BSTSetNode(BSTSetNode l, BSTSetNode r, BSTSetNode p,  int key) {
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
		if(element.getKey() == this.getKey())
		{
			return false;
		}
		else if(this.getKey() > element.getKey())
		{
			if(left == null)
			{
				left = new BSTSetNode(null, null, this, element.getKey());
				return true;
			}
			else
			{
				return left.add(element);
			}

		} else if (this.getKey() < element.getKey()) {
			if(right == null){
				right = new BSTSetNode(null, null, this, element.getKey());
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
	public boolean remove(BSTSetNode element) {
		if(this.getKey() > element.getKey())
		{
			return getLeft() != null && getLeft().remove(element);
		}
		else if(this.getKey() < element.getKey())
		{
			return getRight() != null && getRight().remove(element);
		}
		else {
			if(getLeft() != null && getRight() != null)
			{
				this.setKey(getRight().findMin().getKey());
				getRight().remove(this);
			}
			else if(parent.getLeft() == this)
			{
				BSTSetNode x = getLeft()!= null ? getLeft() : getRight();
				parent.setLeft(x);
			}
			else if(parent.getRight() == this)
			{
				BSTSetNode x = getLeft() != null ? getLeft() : getRight();
				parent.setRight(x);
			}
			return true;
		}
	}

	/**
	 * Checks whether the element with the given key exists in the subtree.
	 * 
	 * @param element Query key wrapped inside an empty BSTNode instance
	 * @return true, if the element is contained in the subtree; false otherwise.
	 */
	public boolean contains(BSTSetNode element) {
		counter++;
		if(this.getKey() == element.getKey())
		{
			return true;
		}
		else if (this.getKey() > element.getKey())
		{
			return left != null && left.contains(element);
		}
		else if(this.getKey() < element.getKey())
		{
			return right != null && right.contains(element);
		}
		return false;
	}

	/**
	 * Finds the smallest element in the subtree.
	 * This function is in some cases used during
	 * the removal of the element.
	 * 
	 * @return Smallest element in the subtree
	 */
	public BSTSetNode findMin()
	{
		return left == null ? this : left.findMin();
	}
	
	/**
	 * Depth-first pre-order traversal of the BST.
	 * 
	 * @return List of elements stored in BST obtained by pre-order traversing the tree.
	 */
	List<Integer> traversePreOrder()
	{
		List<Integer> list = new ArrayList<>();

		Stack<BSTSetNode> stack = new Stack<>();
		stack.push(this);

		while(!stack.isEmpty())
		{
			BSTSetNode n = stack.pop();
			list.add(n.getKey());

			if(n.right != null)
			{
				stack.push(n.right);
			}

			if(n.left != null)
			{
				stack.push(n.left);
			}
		}
		return list;
	}

	/**
	 * Depth-first in-order traversal of the BST.
	 * 
	 * @return List of elements stored in BST obtained by in-order traversing the tree.
	 */
	List<Integer> traverseInOrder()
	{
		List<Integer> list = new ArrayList<>();

		Stack<BSTSetNode> stack = new Stack<>();
		BSTSetNode node = this;

		while(!stack.isEmpty() || node != null)
		{
			if(node != null)
			{
				stack.push(node);
				node = node.left;
			}
			else
			{
				BSTSetNode tmpNode = stack.pop();
				list.add(tmpNode.getKey());
				node = tmpNode.right;
			}
		}

		return list;
	}

	/**
	 * Depth-first post-order traversal of the BST.
	 * 
	 * @return List of elements stored in BST obtained by post-order traversing the tree.
	 */
	List<Integer> traversePostOrder()
	{
		List<Integer> list = new ArrayList<>();

		Stack<BSTSetNode> stack = new Stack<>();
		BSTSetNode node = this;

		while(true)
		{
			if(node != null)
			{
				if(node.right != null)
				{
					stack.push(node.right);
				}

				stack.push(node);
				node = node.left;
				continue;
			}

			if(stack.isEmpty())
			{
				return list;
			}

			node = stack.pop();

			if(node.right != null && !stack.isEmpty() && node.right == stack.peek())
			{
				stack.pop();
				stack.push(node);
				node = node.right;
			}
			else
			{
				list.add(node.getKey());
				node = null;
			}
		}
	}

	/**
	 * Breadth-first (or level-order) traversal of the BST.
	 * 
	 * @return List of elements stored in BST obtained by breadth-first traversal of the tree.
	 */
	List<Integer> traverseLevelOrder()
	{
		List<Integer> list = new ArrayList<>();
		Queue<BSTSetNode> queue = new LinkedList<>();

		queue.add(this);

		while(!queue.isEmpty())
		{
			BSTSetNode node = queue.poll();
			list.add(node.getKey());

			if(node.left != null)
			{
				queue.add(node.left);
			}

			if(node.right != null)
			{
				queue.add(node.right);
			}
		}

		return list;
	}
}