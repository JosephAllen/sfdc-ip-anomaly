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
    IpAddressAnomoly__c ipAnomoly = new IpAddressAnomoly__c();
    ipAnomoly.EventDate__c = (DateTime) ipEvent.get('EventDate');
    ipAnomoly.EventIdentifier__c = (String) ipEvent.get('EventIdentifier');
    ipAnomoly.EventIp__c = (String) ipEvent.get('SourceIp');
    ipAnomoly.LoginApplication__c = loginHistory.Application;
    ipAnomoly.LoginDate__c = loginHistory.LoginTime;
    ipAnomoly.LoginHistoryId__c = loginHistory.Id;
    ipAnomoly.LoginIp__c = loginHistory.SourceIp;
    ipAnomoly.LoginKey__c = (String) ipEvent.get('LoginKey');
    ipAnomoly.LoginType__c = loginHistory.LoginType;
    ipAnomoly.SessionKey__c = (String) ipEvent.get('SessionKey');
    ipAnomoly.User__c = (Id) ipEvent.get('UserId');
    ipAnomoly.EventType__c = getEventType();
    insert ipAnomoly;
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
