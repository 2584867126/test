package data;

public class ListNode {

    int order;
    ListNode next;

    public ListNode(int order, ListNode next) {
        this.order = order;
        this.next = next;
    }

    public static void main(String[] args) {
        ListNode ten = new ListNode(10,null);
        ListNode eight = new ListNode(8,ten);
        ListNode six = new ListNode(6,eight);
        ListNode three = new ListNode(3,six);
        ListNode head = new ListNode(1,three);

    }

    public static ListNode reverseListNode(ListNode head){
        ListNode cur = head;
        ListNode prev = null;
        while (cur != null){
            ListNode next = cur.next;
            cur.next = prev;
            prev = cur;
            cur = next;
        }
        return prev;

    }

//    public static int[] swap(int[] arr){
//        int temp = arr[1];
//        arr[1] = arr[2];
//        arr[2] = temp;
//    }
}
