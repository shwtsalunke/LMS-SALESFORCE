public without sharing class BookRestController {

    @AuraEnabled(cacheable=true)
    public static List<Book__c> getBooks() {
      
        // Comment added for testing CI/CD pipeline
        // comment added for second testing CI/CD pipeline
        // comment added for third testing CI/CD pipeline
        // comment added for 4rth testing CI/CD pipeline
        // commnet added for 5th testing CI/CD pipeline
        // comment added for 6th testing
        try {
            List<Book__c> booksList = [SELECT Id, Name, Genre__c, Availability_Status__c FROM Book__c];
            return booksList.isEmpty() ? new List<Book__c>() : booksList;
        } catch (Exception e) {
            System.debug('=== ERROR: ' + e.getMessage());
            return new List<Book__c>(); // Return empty list instead of throwing an error
        }
    }
}