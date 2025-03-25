@isTest
public class FundedOpportunityControllerTest {
    @isTest
    static void testGetLatestFundedOpportunity() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Funded Opportunity',
            StageName = 'Funded',
            CloseDate = Date.today(),
            AccountId = testAccount.Id
        );
        insert testOpportunity;

        // Call the method
        Opportunity result = FundedOpportunityController.getLatestFundedOpportunity(testAccount.Id);

        // Verify the result
        System.assertNotEquals(null, result, 'The result should not be null');
        System.assertEquals(testOpportunity.Id, result.Id, 'The Opportunity ID should match the test Opportunity ID');
    }
}