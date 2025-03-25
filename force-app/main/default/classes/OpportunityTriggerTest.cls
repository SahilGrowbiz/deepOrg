@isTest
public class OpportunityTriggerTest {
    
    @testSetup
    static void setup() {
        Account parentAccount = new Account(Name = 'Parent Account');
        insert parentAccount;
        
        Account childAccount = new Account(Name = 'Child Account', ParentId = parentAccount.Id);
        insert childAccount;
    }
    
    @isTest
    static void testOpportunityTrigger_InsertUpdateDelete() {
        Account parentAccount = [SELECT Id FROM Account WHERE Name = 'Parent Account' LIMIT 1];
        Account childAccount = [SELECT Id FROM Account WHERE Name = 'Child Account' LIMIT 1];

        Opportunity opp1 = new Opportunity(Name = 'Opportunity 1', AccountId = childAccount.Id, StageName = 'Prospecting', CloseDate = Date.today(), Change_Arr__c = 10000);
        insert opp1;

        childAccount = [SELECT Total_ARR__c FROM Account WHERE Id = :childAccount.Id];
        System.assertEquals(10000, childAccount.Total_ARR__c);

        parentAccount = [SELECT Total_Parent_ARR__c FROM Account WHERE Id = :parentAccount.Id];
        System.assertEquals(10000, parentAccount.Total_Parent_ARR__c);

        opp1.Change_Arr__c = 20000;
        update opp1;

        childAccount = [SELECT Total_ARR__c FROM Account WHERE Id = :childAccount.Id];
        parentAccount = [SELECT Total_Parent_ARR__c FROM Account WHERE Id = :parentAccount.Id];
        System.assertEquals(20000, childAccount.Total_ARR__c);
        System.assertEquals(20000, parentAccount.Total_Parent_ARR__c);

        Opportunity opp2 = new Opportunity(Name = 'Opportunity 2', AccountId = childAccount.Id, StageName = 'Prospecting', CloseDate = Date.today(), Change_Arr__c = 5000);
        insert opp2;

        childAccount = [SELECT Total_ARR__c FROM Account WHERE Id = :childAccount.Id];
        parentAccount = [SELECT Total_Parent_ARR__c FROM Account WHERE Id = :parentAccount.Id];
        System.assertEquals(25000, childAccount.Total_ARR__c);
        System.assertEquals(25000, parentAccount.Total_Parent_ARR__c);

        delete opp1;

        childAccount = [SELECT Total_ARR__c FROM Account WHERE Id = :childAccount.Id];
        parentAccount = [SELECT Total_Parent_ARR__c FROM Account WHERE Id = :parentAccount.Id];
        System.assertEquals(5000, childAccount.Total_ARR__c);
        System.assertEquals(5000, parentAccount.Total_Parent_ARR__c);
    }
}