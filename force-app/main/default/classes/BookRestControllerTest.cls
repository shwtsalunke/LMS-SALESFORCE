@isTest
private class BookRestControllerTest {

    @isTest
    static void testGetBooks() {
        // Step 1: Create test data
        List<Book__c> testBooks = new List<Book__c>{
            new Book__c(Name = 'Book A', Genre__c = 'Fiction', Availability_Status__c = 'Available'),
            new Book__c(Name = 'Book B', Genre__c = 'Non-fiction', Availability_Status__c = 'Checked Out')
        };
        insert testBooks;

        // Step 2: Call the method under test
        Test.startTest();
        List<Book__c> result = BookRestController.getBooks();
        Test.stopTest();

        // Step 3: Assert the results
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(2, result.size(), 'Should return 2 books');
        System.assertEquals('Book A', result[0].Name);
        System.assertEquals('Book B', result[1].Name);
    }

    @isTest
    static void testGetBooksEmpty() {
        // Ensure no records exist
        delete [SELECT Id FROM Book__c];

        Test.startTest();
        List<Book__c> result = BookRestController.getBooks();
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(0, result.size(), 'Should return an empty list');
    }
}
