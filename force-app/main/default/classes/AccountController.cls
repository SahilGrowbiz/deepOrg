/**
 * @description       : 
 * @author            : Sahil Saini SS
 * @group             : 
 * @last modified on  : 03-25-2025
 * @last modified by  : Sahil
**/
public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<String> getAccountFields() {
        Schema.SObjectType accountType = Schema.getGlobalDescribe().get('Account');
        Map<String, Schema.SObjectField> fieldsMap = accountType.getDescribe().fields.getMap();
        
        List<String> fieldsList = new List<String>();
        for (String fieldName : fieldsMap.keySet()) {
            fieldsList.add(fieldName);
        }
        return fieldsList;
    } 

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountRecords(List<String> fieldNames) {
        String query = 'SELECT ' + String.join(fieldNames, ', ') + ' FROM Account LIMIT 100';
        return Database.query(query);
    }
}