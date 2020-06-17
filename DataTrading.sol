pragma solidity ^0.4.11;

library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
          return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);


        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }


    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract Utils {

    function stringToBytes32(string memory source)  internal pure returns (bytes32 result) {
        assembly {
            result := mload(add(source, 32))
        }
    }

    function bytes32ToString(bytes32 x)  internal pure returns (string memory) {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
            byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (j = 0; j < charCount; j++) {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }
}

contract DataTrading is Utils{
    using SafeMath for uint256;
    address owner;
    
           //约束条件——合约创建者
    modifier onlyOwner() {
        if(msg.sender == owner)
        _;
    }
    
    modifier onlyOwnerOf(string _dataUID) {
        require(msg.sender == dataToOwner[_dataUID]);
        _;
    }
       
    //合约构造函数
    constructor() public {
        owner = msg.sender;
    }
    
     function Transfer () public  payable{
        owner = msg.sender;
    }
    
      function getBalance() public view returns(uint){
        return address(this).balance;
    }
    

address public dataRequester;  
uint public selectedNum;
uint public candidateNum;
uint public quLimit;
string public dataStyle;
uint public deadline;
uint public tradingBudget;
string public requestPK;
uint public candidateNumm;
uint public selectedNumm;

bool public Candidata = false;            
bool public selectedData = false;        
bool public dataCrowdClosed = false;        
string[] candidateDataList;     
string[] selectedDataList;      

event DataCrowding(address _requesterAddr,bool isSuccess,string messing);

function dataRequirements(address isDataRequester,uint DA,uint dl,uint CL,uint budget,uint qualityLimit,string PKj,string DS){
    dataRequester = isDataRequester;                    
    selectedNum=DA;                                                        
    candidateNum =DA*CL;                         
    deadline = now + dl * 1 minutes;          
    tradingBudget=budget;                    
    dataStyle=DS;                         
    requestPK=PKj;                          
    quLimit=qualityLimit;                     
    candidateNumm=0;                  
    selectedNumm=0;                      
    
}

address[] datasProvider;
uint[] datasReward; 

struct Data {
        string dataUID;  
        string datastyle;   
        uint amount;     
        uint registerTime;   
        string description; 
        uint tradeNum;      
        string dataHash;    
        string storageProof;
        uint evaluation;  
    address[] transferProcess;  
    uint[] tradingPrice;
    }
  struct DataEve{
      string dataIDi;    
      string integrityEveluate; 
      uint integrityScore; 
      string consistencyEveluate; 
      uint consistencyScore; 
      string  accuracyEveluate; 
      uint  accuracyScore;
      uint qualityScore;
    }
    
    struct DataReward{
      string dataIDi;    
      uint rewardC; 
    }

    mapping(string => Data) datas;    
    string[] datasIDi;      
    
  //  mapping(bytes32 => Data) datas;       
    mapping(string => address) dataToOwner; 
    mapping(string => DataEve) dataeve;     
    mapping(string => DataReward) datareward;      

    address[] dataUsersAddr;  
    string[] datasID;      
    bool [] dataUse;
    uint projectBenefits;
    string public id;
    uint public quanAMOUNT;
    uint[] dataReward;
    uint[] datasquanlity;
    
 event DataAddBlock(address _providerAddr, bool isSuccess, string message);
    function dataSummary(address _providerAddr, string memory _dataUID, string memory _datastyle,  uint _evaluation, uint _amount, string _description, string _storageProof,string _dataHash) public {
            id = _dataUID;
            datas[id].dataUID = id;
            datas[id].registerTime =now;
            datas[id].datastyle = _datastyle;
            datas[id].amount= _amount;
            datas[id].description = _description;
            datas[id].storageProof = _storageProof;
            datas[id].dataHash = _dataHash;
            datas[id].tradeNum = 0;
            datas[id].evaluation = _evaluation;
            datas[id].transferProcess.push(_providerAddr);
            datasID.push(id);
         //   dataUsers[_providerAddr].merchantDatas.push(id);
            dataToOwner[id] = _providerAddr;
            emit DataAddBlock(_providerAddr, true, "注册数据集成功");
            return;
}

    event DataSimiliarCheck(string dataUID,bool isSimiliar,string message);
   function DataSimiliarChecking(string memory _dataUID) public {
    uint length = datasID.length;
     for(uint32 i=0;i<length;i++){
     id=datasID[i];
     if(keccak256(datas[id].dataHash)==keccak256(datas[_dataUID].dataHash)){
      emit DataSimiliarCheck(id,true,"数据集与当前数据集相似");
     }
   }
   } 
    
    
        function EvaluationChain(string memory _dataUID) view public returns ( string, uint,string, uint,string, uint) {
        id = _dataUID;
        return (dataeve[id].integrityEveluate,dataeve[id].integrityScore,dataeve[id].consistencyEveluate,dataeve[id].consistencyScore,dataeve[id].accuracyEveluate,dataeve[id].accuracyScore);
    }
    
        function SummaryChain(string memory _dataUID) view public returns (string, string,string,string,uint,string) {
        id = _dataUID;
        return (datas[id].dataUID,datas[id].datastyle,datas[id].description,datas[id].storageProof,datas[id].amount,datas[id].dataHash);
    }
    
    
     event providerAthtoCan(string _dataUID, bool isSuccess, string message);
    function AthtoCandidateDataList(string memory _dataUID,bytes memory signedString) public returns (bool){
        id=_dataUID;
         require(msg.sender==  dataToOwner[id]);
        if(keccak256(datas[id].datastyle) ==  keccak256(dataStyle)){
             if(datas[id].evaluation>=quLimit){
                if(candidateNum>= candidateNumm){
        require(datas[id].evaluation>=quLimit);
        require(candidateNum>= candidateNumm);
        require(now<deadline);
        candidateDataList.push(id);
        candidateNumm+=datas[id].amount;
         emit providerAthtoCan( _dataUID, true, "数据集加入到候选数据集");
        return;
    }
     else{
    emit providerAthtoCan( _dataUID, false, "候选数据集已完成");
    }
             }
    else{
    emit providerAthtoCan( _dataUID, false, "数据集质量分数低于需求商质量需求");
    }
             }
    else{
    emit providerAthtoCan( _dataUID, false, "数据集不匹配需求商数据类型");
    }
    }
    
      function ShowcandidateDataList() view public returns (uint,uint[] memory, uint[] memory, address[] memory){
          uint length = candidateDataList.length;
          uint[] memory datasPrice = new uint[](length);
          uint[] memory datasQua = new uint[](length);
        address[] memory datasOwner = new address[](length);
          for(uint32 i=0;i<length;i++){
           datasPrice[i] = datas[candidateDataList[i]].amount;
         datasQua[i] = datas[candidateDataList[i]].evaluation;
            datasOwner[i] = dataToOwner[candidateDataList[i]];
      }
       return (length, datasPrice, datasQua, datasOwner);
    }
    
    event chooseToSelectedDataList(string _dataUID, bool isSuccess, string message);
    event DemanderbuyData(address _demanderAddr, bool isSuccess, string message);
     function SelectedDataList(string memory _dataUID,bytes memory signedString) onlyOwner public {
        require(selectedNum>= selectedNumm);
        selectedDataList.push(_dataUID);
        datas[id].tradeNum = datas[_dataUID].tradeNum + 1;
        selectedNumm+=datas[_dataUID].amount;
        datas[id].transferProcess.push( msg.sender);
        emit chooseToSelectedDataList( _dataUID, true, "数据集加入到交易数据集");
        emit DemanderbuyData( msg.sender, true, "购买成功");
        return ;
     }

    event EvaluateData(address _valuator, bool isSuccess, string message);
    function writeEvaluation(string memory _dataUIDi, address _demanderAddr, string memory _integrityEveluate, uint _integrityScore,string memory _consistencyEveluate, uint _consistencyScore,string memory _accuracyEveluate, uint _accuracyScore) public {
        id = _dataUIDi;
        uint temTN= datas[id].tradeNum;
        if(datas[id].transferProcess[temTN] != msg.sender) {
            emit EvaluateData(_demanderAddr, false, "你不是数据使用者，无法评价");
            return;
        }
        else {
            dataeve[id].dataIDi= id;
            dataeve[id].integrityEveluate = _integrityEveluate;
            dataeve[id].integrityScore = _integrityScore;
            dataeve[id].consistencyEveluate = _consistencyEveluate;
            dataeve[id].consistencyScore = _consistencyScore;
            dataeve[id].accuracyEveluate = _accuracyEveluate;
            dataeve[id].accuracyScore = _accuracyScore;
            dataeve[id].qualityScore =_integrityScore+ _consistencyScore+_accuracyScore;
            datasIDi.push(id);
            emit EvaluateData(_demanderAddr, true, "评价成功");
            return;
        }
    }
     
     event showOwner(string _dataUID,address _valuator);
     function showDataToOwner(string _dataUID) public returns (address){
     return dataToOwner[_dataUID];
    emit showOwner(_dataUID,dataToOwner[_dataUID]);
     }
     
    function rewardAssigned() onlyOwner public returns (address[] memory,uint[] memory){
    uint selength=selectedDataList.length;
    string memory uidtemp;
    uint temp1;
    quanAMOUNT=0;
     for(uint32 i=0;i<selength;i++){
          temp1=datas[selectedDataList[i]].amount*dataeve[selectedDataList[i]].qualityScore;
          datasquanlity.push(temp1);               
          quanAMOUNT+=temp1;            
    }
      for(uint32 k=0;k<selength;k++){
             datasProvider.push(dataToOwner[selectedDataList[k]]);  
             datasReward.push(datasquanlity[k]/quanAMOUNT*tradingBudget); 
      }
    return(datasProvider,datasReward);
    }
   
         function showReward() view public returns (uint[] memory){
     return (datasquanlity);
     }
    
 event rewardpay(address datasProvider, uint datasReward);
    function rewardPay(address[] _datasProvider,uint256[] datasReward) payable public returns (bool) {
                require(_datasProvider.length > 0);
                require(msg.sender == owner);
                for(uint32 i=0;i<_datasProvider.length;i++){
                   _datasProvider[i].transfer(datasReward[i]*1000000000000000000);
                  rewardpay(_datasProvider[i], datasReward[i]); 
                }
             return true;
         }
}
