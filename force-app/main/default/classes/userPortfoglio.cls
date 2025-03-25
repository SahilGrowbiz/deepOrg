public with sharing class userPortfoglio {
    @AuraEnabled(cacheable=true)
    public static List<userPortfoglio__c> getPortfolioData() {
        return [SELECT Id, Average_Price__c, BuyVal__c, Currency__c, Current_Value__c, Description__c, G_L__c, GL__c, Price__c, QTY__c FROM userPortfoglio__c];
    }
}