public with sharing class FundedOpportunityController {
    @AuraEnabled(cacheable=true)
    public static Opportunity getLatestFundedOpportunity(Id accountId) {
        List<Opportunity> opportunities = [
            SELECT Id, Name
            FROM Opportunity
            WHERE AccountId = :accountId AND StageName = 'Funded'
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];

        if (!opportunities.isEmpty()) {
            return opportunities[0];
        } else {
            return null;
        }
    }
}