public with sharing class baseHelper {

    /**
     * @description Handles JavaScript errors and logs them.
     * @param e Exception object representing the error.
     * @param context Object context where the error occurred.
     */
    // @AuraEnabled(cacheable=true)
    public static void javaScriptError(Exception e, Object context) {
        // Log the JavaScript error
        System.debug('JavaScript Error: ' + e.getMessage());
        // Additional error handling logic can be added here
    }

    // Add other utility methods as needed
}