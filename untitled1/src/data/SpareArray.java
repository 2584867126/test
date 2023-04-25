package data;

public class SpareArray {
    public static void main(String[] args) {
        int[][] arr = new int[11][11];
        arr[1][2] = 1;
        arr[2][3] = 2;
        for (int[] row: arr) {
            for(int data : row){
                System.out.printf("%d\t",data);
            }
            System.out.println();
        }
        //计算不为0的元素个数
        int sum = 0;
        for (int[] row: arr) {
            for(int data : row){
                if(data != 0){
                    sum ++;
                }
            }
        }
        //创建稀疏数组
        int[][] spareseArray = new int[sum + 1][3];
        spareseArray[0][0] = 11;
        spareseArray[0][1] = 11;
        spareseArray[0][2] = sum;
        //将原始数组赋值给稀疏数组
        int count = 0;
        for (int i = 0; i< arr.length;i++) {
            for(int j = 0; j < arr[i].length;j++){
                if(arr[i][j] != 0){
                    count ++;
                    spareseArray[count][0] = i;
                    spareseArray[count][1] = j;
                    spareseArray[count][2] = arr[i][j];
                }
            }
        }
        //遍历稀疏数组
        for (int i = 0; i< spareseArray.length;i++) {
            for (int j = 0; j < spareseArray[i].length; j++) {
                System.out.printf("%d\t",spareseArray[i][j]);
            }
            System.out.println();
        }
        //稀疏转原始
        int row = spareseArray[0][0];
        int col = spareseArray[0][1];
        int sum1 = spareseArray[0][2];
        int[][] arr1 = new int[row][col];
        for(int i = 1;i <= sum1;i++){
            arr1[spareseArray[i][0]][spareseArray[i][1]] = spareseArray[i][2];
        }

        //遍历原始数组
        for (int i = 0; i< arr1.length;i++) {
            for (int j = 0; j < arr1[i].length; j++) {
                System.out.printf("%d\t",arr1[i][j]);
            }
            System.out.println();
        }

    }
}
