global class ScheduledEmailSender implements Schedulable {
    global void execute(SchedulableContext sc) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // Set the recipient email
        String[] toAddresses = new String[] {'swetasalunke057@gmail.com'};
        mail.setToAddresses(toAddresses);
        
        // Set the email details
        mail.setSubject('Scheduled Email Notification');
        mail.setPlainTextBody('This is a scheduled email sent via Apex.');
        
        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
}