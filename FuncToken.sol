pragma solidity ^0.4.11;
import './IERC20.sol';
import './SafeMath.sol';


/*
防止出现出现overflow 和  underflow attack
*/
contract FuncToken is IERC20{
    
   using SafeMath for uint256; // overlaying safeMath on uint256
    
   //only bring token into existence when sb send eth
   uint public _totalSupply = 0; // change when more ppl send ether 
   
   string public constant symbol = "UIP";
   string public constant name = "Func Token";
   uint8 public constant decimals = 18; // one ether can be broken down to 18 decimal spaces
   
   // 1 ether = 500 Func
   uint256 public constant RATE = 500;
   //add a wallet address
   address public owner;
   
   
   mapping(address => uint256) balances;
   mapping(address => mapping(address => uint256)) allowed;
   
   
   // allow user directly send ether
   function () payable {
       createTokens();
   } 
   
   function FuncToken(){
    //   balances[msg.sender] = _totalSupply;
    owner = msg.sender;
   }
   
   function createTokens() payable {
       // make sure the amt of ether send is greater than zero
       require(msg.value > 0);
       uint256 tokens = msg.value.mul(RATE);
       //add tokens to the balanceS of the SENDER
       balances[msg.sender] = balances[msg.sender].add(tokens);
       
       _totalSupply = _totalSupply.add(tokens);
       
       //transfer the ether to the onwer
       owner.transfer(msg.value);
   }
   
   function totalSupply() constant returns (uint256 totalSupply){
       return _totalSupply;
   }
   function balanceOf(address _owner) constant returns (uint256 balance){
       return balances[_owner];
   }
   
   function transfer (address _to, uint256 _value) returns (bool success){
       // do checks before 
       require(
            balances[msg.sender] >= _value
            && _value > 0
        );
        
        // balances [msg.sender] -= _value;
        balances [msg.sender] = balances[msg.sender].sub(_value);
        // balances [ _to] += _value;
        balances [ _to] = balances[ _to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
   }
   
   
 function transferFrom(address _from, address _to, uint256 _value)
 returns (bool success){
     require(
            allowed[_from][msg.sender] >= _value
            && balances[_from] >= _value
            && _value > 0
        );
        
        // balances[_from] -= _value;
        balances [_from] = balances[_from].sub(_value);
        // balances[_to] += _value;
        balances [ _to] = balances[ _to].add(_value);
        
        // allowed[_from][msg.sender] -= _value;
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value);
        return true;
 }
 
 
    function approve (address _spender, uint256 _value) returns (bool success){
        allowed[msg.sender][_spender] = _value;  
        Approval(msg.sender, _spender, _value);
        return true;
   }
   
   function allowance (address _owner, address _spender) constant returns (uint256 remaining){
       return allowed[_owner][_spender];
   }

}