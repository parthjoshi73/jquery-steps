public class AccountDetailPageController {
    
    //Variables
    String accountId {get; set;}
    public List<Account> accList {get; set;}
    public Account acc {get; set;}
    public List<Opportunity> oppList {get; set;}
    public Opportunity oppObj {get; set;}
    public Boolean showEditMode {get; set;}
    
    //Constructor
    public AccountDetailPageController(ApexPages.StandardController controller){
        
        //Set default value 
        showEditMode = false;
        
        //get Account Id from the Controller
        accountId = controller.getId();
        if(String.isNotBlank(accountId)){
            
            try{
                
                //fetch the Account related to accountId
                accList = [SELECT Id, Name, Website, Email__c, CreatedDate 
                           FROM Account 
                           WHERE id=:accountId 
                           limit 1];
                          
                if(!accList.isEmpty()){
                    acc = accList[0];
                }
                
            }catch(Exception e){
                ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.error,'Unable to find the Account');
                ApexPages.addMessage(msg);
            }
            //Fetch All Opportunity Related to Account
            getOpportunities();
        }
    }
    
    //Fetch All Opportunity Related to Account
    public List<Opportunity> getOpportunities(){
    
        oppList = [SELECT id, Name, Account.Name, CloseDate, Amount, Type 
        FROM Opportunity 
        WHERE Account.id =: accountId];
        return oppList;
    }
    
    //Fetch clicked Opportunity
    public void RetrieveOpportunity() {
        
        Id oppId =  Apexpages.currentPage().getParameters().get('OppId');
        if(String.isNotBlank(oppId)) {
            
            List<Opportunity> fetchedOppList = [SELECT Id, Name, Account.Name, CloseDate, Type, accountid, StageName
                                                FROM Opportunity 
                                                WHERE id =: oppId 
                                                LIMIT 1];
            if(!fetchedOppList.isEmpty()) {
                
                oppObj = fetchedOppList[0];
                showEditMode = true;
            }
        }
    }
    
    //Add nre Opportunity
    public void AddNewOpportunity(){
        oppObj = new Opportunity();
        oppObj.accountId = accountId;
        showEditMode = true;
    }
    
    //cancel Edit Mode
    public void cancelEdit(){
        oppObj = new Opportunity();
        showEditMode = false;
    }
    
    //Save Opportunity
    public void SaveOpportunity(){
        
        if(oppObj != null){
            upsert oppObj;
            showEditMode = false; 
        }
    }
    
    //Delete Opportunity
    public void DeleteOpportunity(){
        
        Id oppId =  Apexpages.currentPage().getParameters().get('OppId');
        if(String.isNotBlank(oppId)) {
            
            List<Opportunity> fetchedOppList = [SELECT Id, Name, Account.Name, CloseDate, Type, accountid, StageName
                                                FROM Opportunity 
                                                WHERE id =: oppId 
                                                LIMIT 1];
            if(!fetchedOppList.isEmpty()) {
                
                delete fetchedOppList; 
            }
        }
    }
}