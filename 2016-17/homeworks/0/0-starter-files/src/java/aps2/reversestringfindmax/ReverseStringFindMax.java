package aps2.reversestringfindmax;

public class ReverseStringFindMax {
	/**
	 * This function takes the string argument and reverses it.
	 * 
	 * @param str Input string.
	 * @return Reverse version of the string or null, if str is null.
	 */
	public String reverseString(String str) {
		String tmp = new String();

		if(str == null)
			return null;

		for(int i = str.length() - 1; i >= 0 ; i--)
		{
			tmp += str.charAt(i);
		}

		return tmp.length() == 0 ? "" : tmp;
	}

	/**
	 * This function finds and returns the maximum element in the given array.
	 * 
	 * @param arr Initialized input array.
	 * @return The maximum element of the given array, or the minimum Integer value, if array is empty.
	 */
	public int findMax(int[] arr){

		if(arr.length == 0)
			return Integer.MIN_VALUE;

		int max = arr[0];

		for(int i = 0; i < arr.length; i++)
		{
			if(arr[i] >  max)
				max = arr[i];
		}

		return max;
	}
}
