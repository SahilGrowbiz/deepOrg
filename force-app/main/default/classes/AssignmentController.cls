public class AssignmentController {

    @AuraEnabled(cacheable = true)
    public static List<Assignment__c> getAssignments() {
        return [SELECT Id, Name, Description__c, Due_Date__c, Due_Date_With_Time__c, Funded__c, Loan_Amount__c
                FROM Assignment__c];
    }

    @AuraEnabled
    public static String createAssignment(String assignmentName, String description, Date dueDate, 
                                          Datetime dueDateTime, Boolean funded, Decimal loanAmount) {
        try {
            Assignment__c newAssignment = new Assignment__c(
                Name = assignmentName,
                Description__c = description,
                Due_Date__c = dueDate,
                Due_Date_With_Time__c = dueDateTime,
                Funded__c = funded,
                Loan_Amount__c = loanAmount
            );
            insert newAssignment;
            return newAssignment.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating assignment: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void updateAssignments(List<Assignment__c> assignments) {
        try {
            update assignments;
        } catch (Exception e) {
            throw new AuraHandledException('Error updating assignments: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteAssignment(Id assignmentId) {
        try {
            Assignment__c assignment = [SELECT Id FROM Assignment__c WHERE Id = :assignmentId LIMIT 1];
            delete assignment;
        } catch (Exception e) {
            throw new AuraHandledException('Error deleting assignment: ' + e.getMessage());
        }
    }
}