public with sharing class FileExplorerController {
    @AuraEnabled
    public static Id createFolder(String name, Id linkedEntityId, Id parentId) {
        Folder_Manager__c folder = new Folder_Manager__c();
        folder.Name = name;
        folder.Linked_Entity_Id__c = linkedEntityId;
        if (parentId != null) {
            folder.ParentId__c = parentId;
        }
        insert folder;
        return folder.Id;
    }

    @AuraEnabled
    public static List<Folder_Manager__c> getFolders(Id linkedEntityId, Id parentId) {
        return [SELECT Id, Name FROM Folder_Manager__c 
                WHERE Linked_Entity_Id__c = :linkedEntityId 
                AND ParentId__c = :parentId];
    }

    @AuraEnabled
    public static Id uploadFile(String name, Id folderId, Id linkedEntityId, String base64Data) {
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = name;
        contentVersion.PathOnClient = name;
        contentVersion.VersionData = EncodingUtil.base64Decode(base64Data);
        insert contentVersion;

        File_Manager__c file = new File_Manager__c();
        file.Name = name;
        file.Folder_Manager__c = folderId;
        file.Linked_Entity_Id__c = linkedEntityId;
        insert file;

        return file.Id;
    }

    @AuraEnabled
    public static List<File_Manager__c> getFiles(Id folderId) {
        return [SELECT Id, Name FROM File_Manager__c 
                WHERE Folder_Manager__c = :folderId];
    }
}