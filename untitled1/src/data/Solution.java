package data;

import java.util.*;

public class Solution {

    public static void main(String[] args) {
        int[] arr = new int[]{5, 3 ,2 ,8 ,7};
        System.out.println(Arrays.toString(bubble(arr)));
    }

    public static int[] insertSort(int[] arr){
        for(int i = 1;i< arr.length -1;i++){  
            int tmp = arr[i];
            int j = i;
            while (j > 0 && tmp < arr[j - 1]){
                arr[j] = arr[j -1];
                j--;
            }
            if(tmp != arr[j]){
                arr[j] = tmp;
            }
        }
        return arr;
    }

    public static int[] choose(int[] arr){

        for(int i = 0;i< arr.length - 1;i++){
            int min = arr[i];
            int minIndex = i;
            for(int j = i + 1;j< arr.length;j++){
                if(arr[j] < min){
                    min = arr[j];
                    minIndex = j;
                }
            }
            if(minIndex != 0){
                int temp = arr[0];
                arr[0] = arr[minIndex];
                arr[minIndex] = temp;
            }
        }
        return arr;
    }


    public static int[] bubble(int[] arr){
        for(int i = 0;i< arr.length - 1;i++){
            for(int j = 0;j<arr.length - 1 - i;j++){
                if(arr[j] > arr[j + 1]){
                    int temp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j+ 1] = temp;
                }
            }
        }
        return arr;
    }


    public static int maxLen(String str){
        Set<Character> set = new HashSet<>();
        int n = str.length();
        int rk = -1,ans = 0;
        for (int i = 0; i < n; i++) {
            if(i != 0){
                set.remove(str.charAt(i - 1));
            }
            while (rk + 1 < n && !set.contains(str.charAt(rk + 1))){
                rk++;
                set.add(str.charAt(rk));
            }
            ans = Math.max(ans,rk - i + 1);
            if((n - i + 1) <= ans){
                return ans;
            }
        }
        return ans;
    }

    public static boolean check1(String a,String b){
        int left = 0;
        int right = a.length() - 1;
        while (left < right && a.charAt(left) == b.charAt(right)){
            left++;
            right--;
        }
        if(left >= right){
            return true;
        }
        return check2(a,left,right) || check2(b,left,right);
    }

    public static boolean check2(String a,int left,int right){
        while (left < right && a.charAt(left) == a.charAt(right)){
            left++;
            right--;
        }
        return left >= right;
    }

    public static boolean huiwen(String orign) {
        int len = orign.length();
        for (int i = 0; i < len/2; i++) {
            if(orign.charAt(i) != orign.charAt(len - i - 1)){
                return false;
            }
        }
        return true;
    }

}
