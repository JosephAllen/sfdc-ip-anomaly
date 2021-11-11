/**
 * Queueable class for handling IP Address Anomalies
 *
 * @author Joseph Allen
 */
public class IpAddressAnomalyHandler implements Queueable {
  private LoginHistory loginHistory;
  private SObject ipEvent;

  /**
   * Constructor for setting local variables
   * @param  loginHistory LoginHistory record matching the LoginHistoryId__c of a peristed ipEvent
   * @param  ipEvent      IP Event that fired the process
   */
  public IpAddressAnomalyHandler(LoginHistory loginHistory, SObject ipEvent) {
    this.loginHistory = loginHistory;
    this.ipEvent = ipEvent;
  }
  /**
   * Executes the queueable job
   * @param  context QueueableContext System Type Containing the job ID
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
   * Gets the Event type for the class level ipEvent variable
   * @return   String representing the EventType name
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
