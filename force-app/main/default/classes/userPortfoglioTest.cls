@isTest
public class userPortfoglioTest {
    @testSetup
    static void setup() {
        // Create test data
        List<userPortfoglio__c> portfolioList = new List<userPortfoglio__c>();
        portfolioList.add(new userPortfoglio__c(
            Average_Price__c = 100.0,
            BuyVal__c = 1000.0,
            Currency__c = 'USD',
            Current_Value__c = 1100.0,
            Description__c = 'Test Description 1',
            G_L__c = 100.0,
            GL__c = 10.0,
            Price__c = 110.0,
            QTY__c = 10
        ));
        portfolioList.add(new userPortfoglio__c(
            Average_Price__c = 200.0,
            BuyVal__c = 2000.0,
            Currency__c = 'EUR',
            Current_Value__c = 2200.0,
            Description__c = 'Test Description 2',
            G_L__c = 200.0,
            GL__c = 20.0,
            Price__c = 220.0,
            QTY__c = 20
        ));
        insert portfolioList;
    }

    @isTest
    static void testGetPortfolioData() {
        // Call the method to be tested
        List<userPortfoglio__c> result = userPortfoglio.getPortfolioData();

        // Verify the results
        System.assertEquals(2, result.size(), 'Expected 2 portfolio records');

        userPortfoglio__c record1 = result[0];
        System.assertEquals(100.0, record1.Average_Price__c, 'Average Price does not match for record 1');
        System.assertEquals(1000.0, record1.BuyVal__c, 'BuyVal does not match for record 1');
        System.assertEquals('USD', record1.Currency__c, 'Currency does not match for record 1');
        System.assertEquals(1100.0, record1.Current_Value__c, 'Current Value does not match for record 1');
        System.assertEquals('Test Description 1', record1.Description__c, 'Description does not match for record 1');
        System.assertEquals(100.0, record1.G_L__c, 'G_L does not match for record 1');
        System.assertEquals(10.0, record1.GL__c, 'GL does not match for record 1');
        System.assertEquals(110.0, record1.Price__c, 'Price does not match for record 1');
        System.assertEquals(10, record1.QTY__c, 'QTY does not match for record 1');

        userPortfoglio__c record2 = result[1];
        System.assertEquals(200.0, record2.Average_Price__c, 'Average Price does not match for record 2');
        System.assertEquals(2000.0, record2.BuyVal__c, 'BuyVal does not match for record 2');
        System.assertEquals('EUR', record2.Currency__c, 'Currency does not match for record 2');
        System.assertEquals(2200.0, record2.Current_Value__c, 'Current Value does not match for record 2');
        System.assertEquals('Test Description 2', record2.Description__c, 'Description does not match for record 2');
        System.assertEquals(200.0, record2.G_L__c, 'G_L does not match for record 2');
        System.assertEquals(20.0, record2.GL__c, 'GL does not match for record 2');
        System.assertEquals(220.0, record2.Price__c, 'Price does not match for record 2');
        System.assertEquals(20, record2.QTY__c, 'QTY does not match for record 2');
    }
}