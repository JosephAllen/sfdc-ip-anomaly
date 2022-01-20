/**
 * Global Class to support Transaction Security Policie
 *
 * @author Joseph Allen
 */
global class IpAddressEventCondition implements TxnSecurity.EventCondition, TxnSecurity.AsyncCondition {
    /**
     * Evaluates is the event is an anomaly
     * @param  event Real Time Event
     * @return       boolean
     */
    public boolean evaluate(SObject event) {
        switch on event {
            when ApiEvent ipEvent {
                return isIpAddressAnomaly(ipEvent);
            }
            when BulkApiResultEvent ipEvent {
                return isIpAddressAnomaly(ipEvent);
            }
            when ListViewEvent ipEvent {
                return isIpAddressAnomaly(ipEvent);
            }
            when ReportEvent ipEvent {
                return isIpAddressAnomaly(ipEvent);
            }
            when null {
                return false;
            }
            when else {
                return false;
            }
        }
    }
    /**
     * Checks is an event is an ip anomaly
     * @param  ipEvent Event Type
     * @return         boolean
     */
    private boolean isIpAddressAnomaly(SObject ipEvent) {
        Id loginHistoryId = (Id) ipEvent.get('LoginHistoryId');
        String sourceIp = (String) ipEvent.get('SourceIp');
        String[] loginHistoryReadFields = new List<String>{
            'Application',
            'LoginTime',
            'LoginType',
            'SourceIp'
        };
        if (!Schema.sObjectType.LoginHistory.isAccessible()) {
            return null;
        }
        Map<String, Schema.SObjectField> m = Schema.SObjectType.LoginHistory.fields.getMap();
        for (String fieldToCheck : loginHistoryReadFields) {
            // Check if the user has create access on the each field
            if (!m.get(fieldToCheck).getDescribe().isAccessible()) {
                return true;
            }
        }

        LoginHistory lh = [
            SELECT Application, LoginTime, LoginType, SourceIp
            FROM LoginHistory
            WHERE Id = :loginHistoryId
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];

        boolean isAnomaly = (lh.SourceIp != sourceIp &&
        appIgnoreList().indexOf(lh.Application) == -1);
        if (isAnomaly) {
            IpAddressAnomalyHandler ipAddressAnomalyHandler = new IpAddressAnomalyHandler(
                lh,
                ipEvent
            );
            System.enqueueJob(ipAddressAnomalyHandler);
        }

        return isAnomaly;
    }
    /**
     * Queries IpIgnoreAppSetting__c custom setting for apps to skip
     * @return   List of Apps to Skip
     */
    private string[] appIgnoreList() {
        IpIgnoreAppSetting__c[] ipIgnoreAppSetting = IpIgnoreAppSetting__c.getall()
            .values();
        String[] appIgnoreList = new List<String>{};
        for (IpIgnoreAppSetting__c ai : IpIgnoreAppSetting) {
            appIgnoreList.add(ai.Name);
        }
        return appIgnoreList;
    }
}
