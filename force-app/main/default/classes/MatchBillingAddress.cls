public class MatchBillingAddress {
    public static void matchPostalCode(List<Account> accounts) {
        for(Account acc: accounts){
            if(acc.Match_Billing_Address__c== true){
                acc.ShippingPostalCode = acc.BillingPostalCode;
            }
        }
    }
}