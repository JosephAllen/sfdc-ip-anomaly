/**
 *
 */
public class IpAddressAnomalyHandler implements Queueable {
  private LoginHistory loginHistory;
  private SObject ipEvent;

  /**
   * @description IpAddressAnomalyHandler description
   * @param  loginHistory loginHistory description
   * @param  ipEvent      ipEvent description
   * @return              return description
   */
  public IpAddressAnomalyHandler(LoginHistory loginHistory, SObject ipEvent) {
    this.loginHistory = loginHistory;
    this.ipEvent = ipEvent;
  }
  /**
   * @description execute description
   * @param  context context description
   */
  public void execute(QueueableContext context) {
    IpAddressAnomaly__c ipAnomaly = new IpAddressAnomaly__c();
    ipAnomaly.EventDate__c = (DateTime) ipEvent.get('EventDate');
    ipAnomaly.EventIdentifier__c = (String) ipEvent.get('EventIdentifier');
    ipAnomaly.EventIp__c = (String) ipEvent.get('SourceIp');
    ipAnomaly.LoginApplication__c = loginHistory.Application;
    ipAnomaly.LoginDate__c = loginHistory.LoginTime;
    ipAnomaly.LoginHistoryId__c = loginHistory.Id;
    ipAnomaly.LoginIp__c = loginHistory.SourceIp;
    ipAnomaly.LoginKey__c = (String) ipEvent.get('LoginKey');
    ipAnomaly.LoginType__c = loginHistory.LoginType;
    ipAnomaly.SessionKey__c = (String) ipEvent.get('SessionKey');
    ipAnomaly.User__c = (Id) ipEvent.get('UserId');
    ipAnomaly.EventType__c = getEventType();
    insert ipAnomaly;
  }
  /**
   * @description getEventType description
   * @return   return description
   */
  private String getEventType() {
    switch on ipEvent {
      when ApiEvent ev {
        return 'ApiEvent';
      }
      when BulkApiResultEvent ev {
        return 'BulkApiResultEvent';
      }
      when ListViewEvent ev {
        return 'ListViewEvent';
      }
      when ReportEvent ev {
        return 'ReportEvent';
      }
      when else {
        return 'unkown';
      }
    }
  }
}