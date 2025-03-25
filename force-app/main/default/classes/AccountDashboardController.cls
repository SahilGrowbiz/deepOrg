// public with sharing class AccountDashboardController {
    
//     @AuraEnabled(cacheable=true)
//     public static List<AssetData> getAssetData() {
//         List<AssetData> assetData = new List<AssetData>();
        
//         // Query custom object records
//         List<AssestData__c> assetRecords = [SELECT Label__c, portfolio_value__c, short_collateral__c, long_loan__c, liquidity__c FROM AssestData__c];
        
//         // Map queried fields to AssetData objects
//         for (AssestData__c asset : assetRecords) {
//             if (asset.Label__c.equals('Portfolio Value') || asset.Label__c.equals('Short Collateral') ||
//                 asset.Label__c.equals('Long Loan') || asset.Label__c.equals('Liquidity')) {
//                 assetData.add(new AssetData(asset.Label__c, asset.portfolio_value__c));
//                 assetData.add(new AssetData(asset.Label__c, asset.short_collateral__c));
//                 assetData.add(new AssetData(asset.Label__c, asset.long_loan__c));
//                 assetData.add(new AssetData(asset.Label__c, asset.liquidity__c));
//             }
//         }
        
//         return assetData;
//     }
    
//     public class AssetData {
//         @AuraEnabled public String label;
//         @AuraEnabled public Decimal value;

//         public AssetData(String label, Decimal value) {
//             this.label = label;
//             this.value = value;
//         }
//     }
// }

// AccountDashboardController.cls

public with sharing class AccountDashboardController {
    @AuraEnabled(cacheable=true)
    public static List<AssetDataWrapper> getAssetData() {
        List<AssetDataWrapper> assetDataList = new List<AssetDataWrapper>();
        
        // Replace with your logic to fetch data from database or other source
        // Example data:
        assetDataList.add(new AssetDataWrapper('Liquidity', 3378.94));
        assetDataList.add(new AssetDataWrapper('Long Loan', 0.00)); // Example, adjust as per actual data
        assetDataList.add(new AssetDataWrapper('Short Collateral', 12489.38));
        assetDataList.add(new AssetDataWrapper('Portfolio Value', 4020.79));

        return assetDataList;
    }

    // Wrapper class to hold data
    public class AssetDataWrapper {
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public Decimal value { get; set; }

        public AssetDataWrapper(String label, Decimal value) {
            this.label = label;
            this.value = value;
        }
    }
}