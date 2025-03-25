public with sharing class dynamicDataTableObjectController {

    @AuraEnabled(cacheable=true)
    public static List<ObjectOption> getObjectOptions() {
        List<ObjectOption> options = new List<ObjectOption>();
        try {
            List<String> sObjectNames = getSObject();
            for (String sObjectName : sObjectNames) {
                options.add(new ObjectOption(sObjectName, sObjectName));
            }
        } catch (Exception e) {
            System.debug('Error in getObjectOptions: ' + e.getMessage());
        }
        return options;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getSObject() {
        List<String> sObjectNames = new List<String>();
        try {
            // Iterate through all SObject types available in the Salesforce schema
            for (Schema.SObjectType sObjectType : Schema.getGlobalDescribe().values()) {
                Schema.DescribeSObjectResult describeResult = sObjectType.getDescribe();

                // Log the SObject being processed
                System.debug('Processing SObject: ' + describeResult.getName());

                // Conditions to filter and include SObjects
                if (!describeResult.isCustomSetting() &&
                    !describeResult.isDeprecatedAndHidden() &&
                    describeResult.isAccessible() &&
                    describeResult.getRecordTypeInfos().size() > 0 &&
                    !String.isEmpty(describeResult.getKeyPrefix()) &&
                    !describeResult.getName().startsWith('User') &&
                    describeResult.isQueryable()) {

                    // Add the SObject name to the list
                    sObjectNames.add(describeResult.getName());
                }
            }

            // Sort the list of SObject names alphabetically
            sObjectNames.sort();

            // Log the final list of SObject names
            System.debug('SObject Names: ' + sObjectNames);
        } catch (Exception e) {
            System.debug('Error in getSObject: ' + e.getMessage());
        }
        return sObjectNames;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getFieldNames(String sObjectName) {
        List<String> fieldNames = new List<String>();
        try {
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            if (schemaMap.containsKey(sObjectName)) {
                Map<String, Schema.SObjectField> fieldMap = schemaMap.get(sObjectName).getDescribe().fields.getMap();
                fieldNames = new List<String>(fieldMap.keySet());

                // Log the fields for the given SObject
                System.debug('Fields for SObject ' + sObjectName + ': ' + fieldNames);
            } else {
                System.debug('SObject name not found in schema: ' + sObjectName);
            }
        } catch (Exception e) {
            System.debug('Error in getFieldNames: ' + e.getMessage());
        }
        return fieldNames;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> fetchDataForFields(String objectName, List<String> fields) {
        List<Map<String, Object>> data = new List<Map<String, Object>>();
        try {
            // Construct a dynamic query to fetch data based on selected fields
            String queryFields = String.join(fields, ',');
            String queryString = 'SELECT ' + queryFields + ' FROM ' + objectName;

            // Log the constructed query
            System.debug('Query: ' + queryString);

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
        } catch (Exception e) {
            // Handle exceptions, such as query limits or invalid field names
            System.debug('Error fetching data: ' + e.getMessage());
        }

        // Log the fetched data
        System.debug('Fetched Data: ' + data);
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