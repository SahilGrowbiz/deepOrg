public with sharing class userOrder {
    @AuraEnabled(cacheable=true)
    public static List<userOrder__c> getUserData() {
        return [SELECT id,Name,Date__c,Detail__c,Executed_Average_price__c,executed_QTY__c,intent__c,Limit_price__c,Price_stop__c,QTY__c,Security__C,State__c,Type__c,Validity__c FROM userOrder__c];
    }
}