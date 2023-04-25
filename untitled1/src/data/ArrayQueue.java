package data;

public class ArrayQueue {
    private int maxSize;
    private int front;
    private int rear;
    private int[] arr;

    public ArrayQueue(int maxSize){
        this.maxSize = maxSize;
        arr = new int[maxSize];
        front = -1;
        rear = -1;
    }
    public boolean isEmpty(){
        return front == rear;
    }
    public boolean isFull(){
        return rear == maxSize - 1;
    }
    public void addData(int n){
        if(isFull()){
            throw new RuntimeException("队列已满");
        }
        front ++;
        arr[front] = n;
    }
    public int getData(){
        if(isEmpty()){
            throw new RuntimeException("队列为空");
        }
        rear++;
        return arr[rear];
    }
    public void showQueue(){
        if(isEmpty()){
            throw new RuntimeException("队列为空");
        }
        for (int i = 0; i < arr.length; i++) {
            System.out.println(arr[i]);
        }
    }

    public static void main(String[] args) {
        ArrayQueue arrayQueue = new ArrayQueue(8);
        arrayQueue.addData(1);
        arrayQueue.addData(3);
        arrayQueue.addData(8);
        arrayQueue.showQueue();
        System.out.println(arrayQueue.getData());
    }

}
