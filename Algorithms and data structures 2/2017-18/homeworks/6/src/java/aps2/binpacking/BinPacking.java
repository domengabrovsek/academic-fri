package aps2.binpacking;

import java.util.*;

/**
 * Bin packing algorithm to compute the minimum number of bins to store all the
 * given items.
 */
	public class BinPacking {
	int[] items; // sizes of items to store
	int m; // size of each bin

	public BinPacking(int[] items, int m) {
		this.items = items;
		this.m = m;
	}

	/**
	 * Computes the strictly minimal number of bins for the given items.
	 *
	 * @return Array of size n which stores the index of bin, where each item is stored in.
	 */
	public int[] binPackingExact()
	{
		int[] positions = new int[items.length];
		List<Integer> indices = new ArrayList<>(items.length);

		for (int i = 0; i < items.length; i++)
		{
			indices.add(i);
		}

		Comparator<Integer> comparator = (i, j) -> -Integer.compare(items[i], items[j]);
		indices.sort(comparator);

		int bin = 0;
		int size = 0;
		while(!indices.isEmpty())
		{
			int index = indices.get(0);
			int value = items[index];

			size += value;
			positions[index] = bin;
			indices.remove(0);

			while (size < m)
			{
				int candidate = binSearch(indices, m - size);
				if(!(candidate < indices.size())) break;

				index = indices.get(candidate);
				value = items[index];
				size += value;
				positions[index] = bin;
				indices.remove(candidate);
			}

			bin++;
			size = 0;
		}

		return positions;
	}

	/**
	 * Uses heuristics (e.g. first-fit, best-fit, ordered first-fit etc.) to
	 * compute the minimal number of bins for the given items. The smaller the
	 * number, the more tests you will pass.
	 *
	 * @return Array of size n which stores the index of bin, where each item is stored in.
	 */
	public int[] binPackingApproximate()
	{
		int index = 0;
		int[] binIndex = new int[items.length];
		int[] array = new int[min()];

		for (int i = 0; i < min(); i++)
		{
			array[i] = 0;
		}

		Arrays.sort(items);

		for (int i = 0; i < items.length / 2; i++)
		{
			int temp = items[i];
			items[i] = items[items.length - i - 1];
			items[items.length - i - 1] = temp;
		}

		for (int item : items)
		{
			for (int j = 0; j < array.length; j++)
			{
				if (array[j] + item <= m)
				{
					array[j] += item;
					binIndex[index] = j;
					index++;
					break;
				}
			}
		}
		return binIndex;
	}

	private int binSearch(List<Integer> list, Integer input)
	{
		int low = 0;
		int high = list.size();

		while (low != high)
		{
			int mid = (low + high) / 2;
			if (items[list.get(mid)] > input)
			{
				low = mid + 1;
			}
			else
			{
				high = mid;
			}
		}

		return low;
	}

	private int min() {
		int sum = 0;
		for (int item : items)
		{
			sum += item;
		}
		return sum / m;
	}
}