package aps2.binomialheap;

import java.util.*;
import java.util.function.BinaryOperator;

/**
 * This class is an implementation of the Binomial min-heap.
 */
public class BinomialHeap {
    Vector<BinomialNode> data; // list of root nodes
    int n;                     // number of elements
    BinomialNode currentMin = new BinomialNode(Integer.MAX_VALUE); // current min element

    // map of all trees with sizes
    Map<Integer, Integer> sizes = new HashMap<>();

    BinomialHeap() {
        data = new Vector<BinomialNode>();
    }

    /**
     * Inserts a new key to the binomial heap and consolidates the heap.
     * Duplicates are allowed.
     *
     * @param key Key to be inserted
     * @return True, if the insertion was successful; False otherwise.
     */
    public boolean insert(int key) {

        // create new binomial tree (node)
        BinomialNode node = new BinomialNode(key);

        // if heap is empty
        if (isEmpty()) {
            data.add(0, node);

            // one tree with k = 0
            sizes.put(0, 1);
            n = 1;
        }
        // consolidate heap by merging trees with same degree
        else {
            data.add(0, node);

            // if already contains tree with k = 0, increase counter for it
            if(sizes.containsKey(0)){
                sizes.put(0, sizes.get(0) + 1);
                consolidate();
            }
            n += 1;
        }

        // save min node to have getMin() => O(1)
        if (key < currentMin.getKey()) {
            currentMin = node;
        }

        return true;
    }

    /**
     * Returns the minimum element in the binomial heap. If the heap is empty,
     * return the maximum integer value.
     *
     * @return The minimum element in the heap or the maximum integer value, if the heap is empty.
     */
    public int getMin() {
        return isEmpty() ? Integer.MAX_VALUE : currentMin.getKey();
    }

    /**
     * Find and removes the minimum element in the binomial heap and
     * consolidates the heap.
     *
     * @return True, if the element was deleted; False otherwise.
     */
    public boolean delMin() {

        boolean wasMinRemoved = currentMin != null;

        // cannot delete anything if heap is empty
        if(isEmpty()) return false;

        // each child of deleted min becomes a new tree
        Vector<BinomialNode> children = findMin().getChildren();
        for(int i = 0; i < findMin().getChildren().size(); i++){
            data.add(children.elementAt(i));
        }

        // remove current min
        data.remove(data.indexOf(findMin()));

        // decrease count of total elements
        n -= 1;

        // because min was deleted we need new min
        currentMin = findMin();

        return wasMinRemoved;
    }

    private BinomialNode findMin(){

        if(isEmpty()) return null;
        int min = Integer.MAX_VALUE;
        BinomialNode node = null;

        for(int i = 0; i < data.size(); i++){
            if(data.get(i).getKey() < min){
                min = data.get(i).getKey();
                node = data.get(i);
            }
        }

        return node;
    }

    /**
     * Merges two binomial trees.
     *
     * @param t1 The first tree
     * @param t2 The second tree
     * @return Returns the new parent tree
     */
    public static BinomialNode mergeTrees(BinomialNode t1, BinomialNode t2) {
        BinomialNode newNode;

        int compareResult = t1.compare(t2);

        // t2.root < t1.root => t2 is new root
        if (compareResult == -1) {
            newNode = new BinomialNode(t2.getKey());

            int t2ChildrenSize = t2.getChildren().size();

            // if any children then add all to new tree
            if(t2ChildrenSize > 0){
                for(int i = 0; i < t2ChildrenSize; i++){
                    newNode.addChild(t2.getChildren().get(i));
                }
            }

            // add whole other tree as child
            newNode.addChild(t1);
        }

        // t1.root < t2.root => t1 is new root
        else {
            newNode = new BinomialNode(t1.getKey());

            int t1ChildrenSize = t1.getChildren().size();

            // if any children then add all to new tree
            if(t1ChildrenSize > 0){
                for(int i = 0; i < t1ChildrenSize; i++){
                    newNode.addChild(t1.getChildren().get(i));
                }
            }

            // add whole other tree as child
            newNode.addChild(t2);
        }

        return newNode;
    }

    /**
     * This function consolidates the binomial heap ie. merges the binomial
     * trees with the same degree into a single one.
     *
     * @return True, if changes were made to the list of root nodes; False otherwise.
     */
    private boolean consolidate() {
        // empty heap or with 1 tree then no changes were made
        if (data.size() <= 1) {
            return false;
        }

        boolean needToConsolidate = true;
        boolean changed = false;
        int i = 0;
        BinomialNode newTree;

        while(needToConsolidate){
            // go through all trees and check if consolidation is needed
            while(i < data.size()){
                // if tree exists in heap
                if(sizes.containsKey(i)){
                    int currentSize = sizes.get(i);
                    // if there are more than one tree with same size we need to merge
                    if(currentSize > 1){
                        i = 0;
                        BinomialNode t1 = data.get(i);
                        BinomialNode t2 = data.get(i + 1);

                        // merge tree to a new one
                        newTree = mergeTrees(t1, t2);

                        // increase count for tree with new size
                        if(sizes.containsKey(newTree.getDegree())){
                            sizes.put(newTree.getDegree(), sizes.get(newTree.getDegree()) + 1);
                        }
                        else{
                            sizes.put(newTree.getDegree(), 1);
                        }

                        // set previous size tree count to 0
                        sizes.put(newTree.getDegree() - 1, 0);

                        // remove old tree and add merged tree
                        data.remove(0);
                        data.set(0, newTree);

                        changed = true;
                    }
                }
                i++;
            }
            needToConsolidate = false;
        }

        return changed;
    }

    private boolean isEmpty() {
        return n == 0;
    }
}