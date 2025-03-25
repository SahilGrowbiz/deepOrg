public with sharing class ObjectController {

    @AuraEnabled(cacheable=true)
    public static List<ObjectOption> getObjectOptions() {
        List<ObjectOption> options = new List<ObjectOption>();
        List<String> sObjectNames = getSObject();
        for (String sObjectName : sObjectNames) {
            options.add(new ObjectOption(sObjectName, sObjectName));
        }
        return options;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getSObject() {
        List<String> sObjectNames = new List<String>();
        
        // Iterate through all SObject types available in the Salesforce schema
        for (Schema.SObjectType sObjectType : Schema.getGlobalDescribe().values()) {
            Schema.DescribeSObjectResult describeResult = sObjectType.getDescribe();
            
            // Conditions to filter and include SObjects
            if (!describeResult.isCustomSetting() &&                          // Exclude custom settings
                !describeResult.isDeprecatedAndHidden() &&                    // Exclude deprecated and hidden objects
                describeResult.isAccessible() &&                              // Ensure the object is accessible to the user
                describeResult.getRecordTypeInfos().size() > 0 &&             // Exclude metadata objects
                !String.isEmpty(describeResult.getKeyPrefix()) &&             // Exclude objects without a key prefix
                !describeResult.getName().startsWith('User') &&               // Optionally exclude User-related objects
                describeResult.isQueryable()) {                               // Ensure the object is queryable
                
                // Add the SObject name to the list
                sObjectNames.add(describeResult.getName());
            }
        }
        
        // Sort the list of SObject names alphabetically
        sObjectNames.sort();
        
        // Return the list of SObject names
        return sObjectNames;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getFieldNames(String sObjectName) {
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(sObjectName).getDescribe().fields.getMap();
        return new List<String>(fieldMap.keySet());
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> fetchDataForFields(String objectName, List<String> fields) {
    List<Map<String, Object>> data = new List<Map<String, Object>>();
    
    // Construct a dynamic query to fetch data based on selected fields
    String queryFields = String.join(fields, ',');
    String queryString = 'SELECT ' + queryFields + ' FROM ' + objectName + ' LIMIT 10';
    
    // Execute the dynamic query
    List<SObject> records = Database.query(queryString);
    
    // Iterate through the queried records
    for (SObject record : records) {
        Map<String, Object> row = new Map<String, Object>();
        
        // Populate the row map with field-value pairs
        for (String field : fields) {
            row.put(field, record.get(field));
        }
        
        // Add the populated row map to the data list
        data.add(row);
    }
    
    return data;
}


    // Inner class to hold object options for combobox
    public class ObjectOption {
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String value { get; set; }

        public ObjectOption(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
}


































// public with sharing class ObjectController {

//     public class ObjectOption {
//         @AuraEnabled public String label { get; set; }
//         @AuraEnabled public String value { get; set; }

//         public ObjectOption(String label, String value) {
//             this.label = label;
//             this.value = value;
//         }
//     }

//     // Method to fetch object options for combobox
//     @AuraEnabled(cacheable=true)
//     public static List<ObjectOption> getObjectOptions() {
//         List<ObjectOption> options = new List<ObjectOption>();
//         options.add(new ObjectOption('Account', 'Account'));
//         // Add other SObjects if needed
//         return options;
//     }

//     // Method to fetch field names dynamically
//     @AuraEnabled(cacheable=true)
//     public static List<String> getFieldNames(String sObjectName) {
//         Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
//         Map<String, Schema.SObjectField> fieldMap = schemaMap.get(sObjectName).getDescribe().fields.getMap();
//         return new List<String>(fieldMap.keySet());
//     }

//     //fetch the data dynamically
//     @AuraEnabled(cacheable=true)
//     public static List<Map<String, Object>> fetchDataForFields(String objectName, List<String> fields) {
//         String queryFields = String.join(fields, ',');
//         String queryString = 'SELECT ' + queryFields + ' FROM ' + objectName;
//         List<Map<String, Object>> records = new List<Map<String, Object>>();

//         try {
//             List<SObject> sObjects = Database.query(queryString);
//             for (SObject sObj : sObjects) {
//                 Map<String, Object> recordMap = new Map<String, Object>();
//                 for (String fieldName : fields) {
//                     recordMap.put(fieldName, sObj.get(fieldName));
//                 }
//                 records.add(recordMap);
//             }
//         } catch (Exception e) {
//             System.debug('Error fetching data: ' + e.getMessage());
//         }
        
//         return records;
//     }
// }