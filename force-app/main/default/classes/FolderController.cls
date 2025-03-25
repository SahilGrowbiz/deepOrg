public with sharing class FolderController {
    // @AuraEnabled
    // public static void createFolderRecord(String folderName, String linkId) {
    //     // Create a new Folder record in the custom object
    //     Custom_Folder__c folder = new Custom_Folder__c();
    //     folder.Folder_Name__c = folderName;  // Set the Folder Name (Folder_Name__c)
    //     folder.Link_Id__c = linkId;  // Set the Link Id to relate to the record
    //     folder.OwnerId = UserInfo.getUserId();  // Set the Owner to the current user
    //     insert folder;
    // }

    // @AuraEnabled(cacheable=true)
    // public static List<Map<String, Object>> getFoldersAndFiles(String linkedEntityId) {
    //     List<Map<String, Object>> result = new List<Map<String, Object>>();
        
    //     // Query for folders
    //     List<Folder_Manager__c> folders = [
    //         SELECT Id, Name, ParentId__c, Linked_Entity_Id__c
    //         FROM Folder_Manager__c
    //         WHERE Linked_Entity_Id__c = :linkedEntityId
    //     ];
        
    //     // Query for files
    //     List<ContentDocumentLink> files = [
    //         SELECT ContentDocumentId, LinkedEntityId, ContentDocument.Title
    //         FROM ContentDocumentLink
    //         WHERE LinkedEntityId IN :folders
    //     ];
        
    //     // Map folders to the structure expected by the LWC
    //     for (Folder_Manager__c folder : folders) {
    //         result.add(new Map<String, Object>{
    //             'Id' => folder.Id,
    //             'Name' => folder.Name,
    //             'ParentId__c' => folder.ParentId__c,
    //             'type' => 'folder'
    //         });
    //     }

    //     // Map files to the structure expected by the LWC
    //     for (ContentDocumentLink fileLink : files) {
    //         ContentDocument file = [
    //             SELECT Id, Title FROM ContentDocument WHERE Id = :fileLink.ContentDocumentId LIMIT 1
    //         ];
    //         result.add(new Map<String, Object>{
    //             'Id' => file.Id,
    //             'Name' => file.Title,
    //             'ParentId__c' => fileLink.LinkedEntityId,
    //             'type' => 'file'
    //         });
    //     }
        
    //     return result;
    // }

    // @AuraEnabled
    // public static Folder_Manager__c createFolder(String folderName, String linkedEntityId, String parentId) {
    //     Folder_Manager__c newFolder = new Folder_Manager__c(
    //         Name = folderName,
    //         Linked_Entity_Id__c = linkedEntityId,
    //         ParentId__c = parentId
    //     );
    //     insert newFolder;
    //     return newFolder;
    // }

     @AuraEnabled(cacheable=true)
        public static List<Folder_Manager__c> getFolders(Id linkedEntityId) {
            return [SELECT Id, Name, Linked_Entity_Id__c, ParentId__c 
                    FROM Folder_Manager__c 
                    WHERE Linked_Entity_Id__c = :linkedEntityId 
                    ORDER BY Name];
        }
    
        @AuraEnabled
        public static Folder_Manager__c createFolder(String folderName, Id linkedEntityId, Id parentId) {
            Folder_Manager__c newFolder = new Folder_Manager__c();
            newFolder.Name = folderName;
            newFolder.Linked_Entity_Id__c = linkedEntityId;
            if (parentId != null) {
                newFolder.ParentId__c = parentId;
            }
            insert newFolder;
            return newFolder;
        }

        @AuraEnabled
    public static void associateFilesToFolder(List<Id> fileIds, Id folderId, Id recordId) {
        List<ContentDocumentLink> cdl = new List<ContentDocumentLink>();
        for(Id fileId : fileIds) {
            ContentDocumentLink cd = new ContentDocumentLink();
            cd.ContentDocumentId = fileId;
            cd.LinkedEntityId = folderId;
            cd.ShareType = 'I'; // Assuming 'I' for Inferred permission, adjust as necessary.
            cdl.add(cd);
        }

        insert cdl;
    }
}