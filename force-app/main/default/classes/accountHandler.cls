public class accountHandler {
    public static void insertAccount(Integer value){
     	Integer N = 1;
        List<Account> addAccounts = new List<Account>();
        while(N<=value){
            Account store = new Account();
            store.Name = 'Acme Inc' + N;
            store.AccountNumber = 'A000'+N;
            addAccounts.add(store);  
            N = N+1;
        }
        insert addAccounts;
    }
}