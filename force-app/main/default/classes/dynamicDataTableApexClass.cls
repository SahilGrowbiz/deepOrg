public with sharing class dynamicDataTableApexClass {
    
    @AuraEnabled
    public static List<PickListWrapper> getSobjectList(){
        try{
            List<PickListWrapper> sobjectOptions = new List<PickListWrapper>();
            for (Schema.SObjectType sobjType : Schema.getGlobalDescribe().values()){
                Schema.DescribeSObjectResult sobjRslt = sobjType.getDescribe();
                if ((sobjRslt.isAccessible() && sobjRslt.isCreateable() && sobjRslt.isQueryable() && sobjRslt.isSearchable() && sobjRslt.isUpdateable()) || sobjRslt.getName() == 'EntitySubscription'){
                    PickListWrapper sobjOption = new PickListWrapper();
                    sobjOption.label = sobjType.getDescribe().getLabel();
                    sobjOption.value = sobjType.getDescribe().getName();
                    sobjectOptions.add(sobjOption);
                }
            }
            return sobjectOptions;
        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<FieldWrapper> getSobjectFieldsList(String sObjectName){
        try{
            List<FieldWrapper> fieldOptions = new List<FieldWrapper>();
            if(String.isNotEmpty(sObjectName)){
                Map <String,Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
                if(globalDescribe.containsKey(sObjectName)){
                    Schema.SObjectType sobjType = globalDescribe.get(sObjectName);
                    Schema.DescribeSObjectResult sobj = sobjType.getDescribe();
                    Map<String, Schema.SObjectField> mapOfField = sobj.fields.getMap();
                    for(String fieldName : mapOfField.keySet())
                    {
                        FieldWrapper fieldOption = new FieldWrapper();
                        Schema.SObjectField field = mapOfField.get(fieldName);
                        Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                        fieldOption.label = fieldDescribe.getLabel();
                        fieldOption.fieldApiName = fieldDescribe.getName();
                        fieldOption.type = String.valueOf(fieldDescribe.getType()).toLowerCase();
                        fieldOptions.add(fieldOption);
                    }
                }
            }
            return fieldOptions;
        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }


    public class PickListWrapper{
        @AuraEnabled
        public string label;
        @AuraEnabled
        public string value;
    }

    public class FieldWrapper{
        @AuraEnabled
        public string label;
        @AuraEnabled
        public string fieldApiName;
        @AuraEnabled
        public string type;
    }
}