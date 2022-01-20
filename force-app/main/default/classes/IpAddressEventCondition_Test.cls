/**
 * Tests for the IpAddressEventCondition class, to make sure that our Transaction Security Apex
 * logic handles events and event field values as expected.
 */
@isTest
public class IpAddressEventCondition_Test {
    @testSetup
    private static void loadSetupData() {
    }
    /**
     * Positive test case 1: If an ApiEvent has Lead as a queried entity and more than 2000 rows
     * processed, then the evaluate method of our policy's Apex should return true.
     */
    static testMethod void apiEventPositiveTest() {
        LoginHistory lh = getLoginHistory();
        // set up our event and its field values
        ApiEvent testEvent = new ApiEvent();

        testEvent.LoginHistoryId = lh.Id;
        testEvent.SourceIp = '1.1.1.1';

        // test that the Apex returns true for this event
        IpAddressEventCondition eventCondition = new IpAddressEventCondition();
        System.assert(eventCondition.evaluate(testEvent));
    }
    static testMethod void bulkApiResultEventPositiveTest() {
        LoginHistory lh = getLoginHistory();

        // set up our event and its field values
        BulkApiResultEvent testEvent = new BulkApiResultEvent();

        testEvent.LoginHistoryId = lh.Id;
        testEvent.SourceIp = '1.1.1.1';

        // test that the Apex returns true for this event
        IpAddressEventCondition eventCondition = new IpAddressEventCondition();
        System.assert(eventCondition.evaluate(testEvent));
    }
    static testMethod void listViewEventPositiveTest() {
        LoginHistory lh = getLoginHistory();

        // set up our event and its field values
        ListViewEvent testEvent = new ListViewEvent();

        testEvent.LoginHistoryId = lh.Id;
        testEvent.SourceIp = '1.1.1.1';

        // test that the Apex returns true for this event
        IpAddressEventCondition eventCondition = new IpAddressEventCondition();
        System.assert(eventCondition.evaluate(testEvent));
    }
    static testMethod void reportEventPositiveTest() {
        LoginHistory lh = getLoginHistory();

        // set up our event and its field values
        ReportEvent testEvent = new ReportEvent();

        testEvent.LoginHistoryId = lh.Id;
        testEvent.SourceIp = '1.1.1.1';

        // test that the Apex returns true for this event
        IpAddressEventCondition eventCondition = new IpAddressEventCondition();
        System.assert(eventCondition.evaluate(testEvent));
    }
    static LoginHistory getLoginHistory() {
        return [SELECT Application, LoginTime, LoginType, SourceIp FROM LoginHistory LIMIT 1];
    }
}
