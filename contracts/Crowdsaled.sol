pragma solidity ^0.4.19;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
contract Crowdsaled is Ownable {
        address public crowdsaleContract = address(0);
        function Crowdsaled() public {
        }

        modifier onlyCrowdsale{
          require(msg.sender == crowdsaleContract);
          _;
        }

        modifier onlyCrowdsaleOrOwner {
          require((msg.sender == crowdsaleContract) || (msg.sender == owner));
          _;
        }

        function setCrowdsale(address crowdsale) public onlyOwner() {
                crowdsaleContract = crowdsale;
        }
}
