public class sumOddNumber {
    public static void calculateSum(){
    List<Integer> oddNumber = new List<Integer>();
    for(Integer i=1;i<=20;i++){
        if(Math.Mod(i,2) !=0){
            oddNumber.add(i);
            System.debug(i);
        }
    }
    Integer sum = 0;
    for(Integer i=0;i<oddNumber.size();i++){
        if(Math.Mod(i,2) == 0){
            sum+=oddNumber.get(i);
            System.debug(oddNumber.get(i));
        }
    }
    System.debug(sum);
}
}