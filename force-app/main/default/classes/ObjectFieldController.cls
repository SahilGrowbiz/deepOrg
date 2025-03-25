public with sharing class ObjectFieldController {

    @AuraEnabled(cacheable=true)
    public static List<FieldInfo> getObjectFields(String objectName) {
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Map<String, Schema.SObjectField> fieldsMap = objDescribe.fields.getMap();

        List<FieldInfo> fieldsList = new List<FieldInfo>();
        for (Schema.SObjectField field : fieldsMap.values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            fieldsList.add(new FieldInfo(
                fieldDescribe.getLabel(), 
                fieldDescribe.getName()
            ));
        }
        return fieldsList;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getObjectData(String objectName, List<String> fields) {
        String query = 'SELECT ' + String.join(fields, ', ') + ' FROM ' + objectName + ' LIMIT 100'; // Limiting the records
        List<SObject> records = Database.query(query);

        List<Map<String, Object>> data = new List<Map<String, Object>>();
        for (SObject record : records) {
            Map<String, Object> recordData = new Map<String, Object>();
            for (String field : fields) {
                recordData.put(field, record.get(field));
            }
            data.add(recordData);
        }
        return data;
    }

    public class FieldInfo {
        @AuraEnabled public String label { get; set; }
        @AuraEnabled public String fieldName { get; set; }

        public FieldInfo(String label, String fieldName) {
            this.label = label;
            this.fieldName = fieldName;
        }
    }
}