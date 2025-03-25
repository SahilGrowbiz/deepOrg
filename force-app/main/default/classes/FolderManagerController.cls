public with sharing class FolderManagerController {

    @AuraEnabled
    public static void createFolder(String folderName, Id recordId, Id ParentId) {
        try {

            Folder_Manager__c folder = new Folder_Manager__c();
            folder.Name = folderName;
            folder.Linked_Entity_Id__c = recordId;
            System.debug(ParentId);
            if (ParentId != null) {
                folder.ParentId__c = ParentId;
            }
            insert folder;

            
        } catch (Exception e) {
            System.debug('Error in createFolder: ' + e.getMessage());
            throw new AuraHandledException('An error occurred while creating the folder: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Folder_Manager__c> getFoldersForRecord(Id recordId) {
    try {
        return [
            SELECT Id, Name, ParentId__c 
            FROM Folder_Manager__c 
            WHERE Linked_Entity_Id__c = :recordId
        ];
    } catch (Exception e) {
        System.debug('Error in getFoldersForRecord: ' + e.getMessage());
        throw new AuraHandledException('An error occurred while retrieving folders: ' + e.getMessage());
    }
    }

    @AuraEnabled
    public static List<Folder_Manager__c> getAllFoldersForRecord(Id getFolderId) {
        try {
            return [
                SELECT Id, Name 
                FROM Folder_Manager__c 
                WHERE ParentId__c = :getFolderId
            ];
        } catch (Exception e) {
            System.debug('Error in getAllFoldersForRecord: ' + e.getMessage());
            throw new AuraHandledException('An error occurred while retrieving folders: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static List<ContentDocument> getAllFilesForFolder(Id getFileId) {
    try {

        List<File_Manager__c> filesLinks = [
            SELECT Id, Content_Document_Id__c 
            FROM File_Manager__c 
            WHERE Folder_Manager__c = :getFileId
        ];

        List<Id> filesIds = new List<Id>();
        for (File_Manager__c fileLink : filesLinks) {
            filesIds.add(fileLink.Content_Document_Id__c);
        }

        if (!filesIds.isEmpty()) {
            return [
                SELECT Id, Title, FileType, CreatedDate, LastModifiedDate, LatestPublishedVersionId 
                FROM ContentDocument 
                WHERE Id IN :filesIds
            ];
        } else {
            return new List<ContentDocument>();
        }
    } catch (Exception e) {
        System.debug('Error in getAllFilesForRecord: ' + e.getMessage());
        throw new AuraHandledException('An error occurred while retrieving files: ' + e.getMessage());
    }
}


    @AuraEnabled
    public static void associateFilesToFolder(List<Id> fileIds, Id folderId) {
        try {
            File_Manager__c file = new File_Manager__c();
            file.Folder_Manager__c = folderId;
            file.Content_Document_Id__c	= fileIds[0];
            insert file;
        } catch (Exception e) {
            System.debug('Error in associateFilesToFolder: ' + e.getMessage());
            throw new AuraHandledException('An error occurred while associating files with the folder: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void moveFileToFolder(Id fileToMove, Id getFolderId){
        try {
            System.debug(fileToMove+','+getFolderId);
            File_Manager__c file = [
                SELECT Id, Folder_Manager__c
                FROM File_Manager__c 
                WHERE Content_Document_Id__c = :fileToMove
            ];
            file.Folder_Manager__c = getFolderId;
            update file;

            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Id getFolder(Id folderCheckId) {
        try {
            System.debug(folderCheckId);
            Folder_Manager__c folder = [SELECT Id FROM Folder_Manager__c WHERE Id = :folderCheckId LIMIT 1];
            if(folder != null){
                return folderCheckId;
            }
            return null;
        }catch (Exception e) {
            throw new AuraHandledException('An unexpected error occurred: ' + e.getMessage());
        }
    }


}