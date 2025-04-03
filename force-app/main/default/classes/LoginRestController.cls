@RestResource(urlMapping='/login/*')
global without sharing class LoginRestController {

    // Wrapper Class for JSON Response
    global class LoginResponse {
        public Boolean success { get; set; }
        public String message { get; set; }
        public String memberId { get; set; }
        public String sessionToken { get; set; }

        public LoginResponse(Boolean success, String message, String memberId, String sessionToken) {
            this.success = success;
            this.message = message;
            this.memberId = memberId;
            this.sessionToken = sessionToken;
        }
    }

    @HttpPost
global static void login() {
    RestResponse res = RestContext.response;
    res.addHeader('Content-Type', 'application/json');
    
    try {
        RestRequest req = RestContext.request;
        String requestBody = req.requestBody.toString();
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(requestBody);

        String email = (String) data.get('email');
        String password = (String) data.get('password');

        if (String.isBlank(email) || String.isBlank(password)) {
            res.responseBody = Blob.valueOf(JSON.serialize(new LoginResponse(false, 'Email and Password are required.', null, null)));
            return;
        }

        // Hash the incoming password for comparison
        String hashedInputPassword = EncodingUtil.base64Encode(Crypto.generateDigest('SHA-256', Blob.valueOf(password)));

        // Find the member with this email
        List<Member__c> members = [SELECT Id, Password__c FROM Member__c WHERE Email__c = :email LIMIT 1];

        if (members.isEmpty() || members[0].Password__c != hashedInputPassword) {
            res.responseBody = Blob.valueOf(JSON.serialize(new LoginResponse(false, 'Invalid email or password.', null, null)));
            return;
        }

        // Generate a session token
        String rawToken = String.valueOf(System.now().getTime()) + Math.random();
        Blob hash = Crypto.generateDigest('SHA-256', Blob.valueOf(rawToken));
        String sessionToken = EncodingUtil.base64Encode(hash);

        // Store session token in Member__c (Ensure `Session_Token__c` field exists)
        members[0].Session_Token__c = sessionToken;
        update members[0];

        res.responseBody = Blob.valueOf(JSON.serialize(new LoginResponse(true, 'Login successful!', members[0].Id, sessionToken)));

    } catch (Exception e) {
        res.responseBody = Blob.valueOf(JSON.serialize(new LoginResponse(false, 'Error: ' + e.getMessage(), null, null)));
    }
}
}