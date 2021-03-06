pragma solidity ^0.4.19;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract WithBonusPeriods is Ownable {
  uint256 constant INVALID_FROM_TIMESTAMP = 1000000000000;
  uint256 constant INFINITY_TO_TIMESTAMP= 1000000000000;
  struct BonusPeriod {
    uint256 fromTimestamp;
    uint256 toTimestamp;
    uint256 bonusNumerator;
    uint256 bonusDenominator;
  }

  BonusPeriod[] public bonusPeriods;
  BonusPeriod currentBonusPeriod;

  function WithBonusPeriods() public {
      initBonuses();
  }

  function BonusPeriodsCount() public view returns (uint8) {
    return uint8(bonusPeriods.length);
  }

  //find out bonus for specific timestamp
  function BonusPeriodFor(uint256 timestamp) public view returns (bool ongoing, uint256 from, uint256 to, uint256 num, uint256 den) {
    for(uint i = 0; i < bonusPeriods.length; i++)
      if (bonusPeriods[i].fromTimestamp <= timestamp && bonusPeriods[i].toTimestamp >= timestamp)
        return (true, bonusPeriods[i].fromTimestamp, bonusPeriods[i].toTimestamp, bonusPeriods[i].bonusNumerator,
          bonusPeriods[i].bonusDenominator);
    return (false, 0, 0, 0, 0);
  }

  function initBonusPeriod(uint256 from, uint256 to, uint256 num, uint256 den) internal  {
    bonusPeriods.push(BonusPeriod(from, to, num, den));
  }

  function initBonuses() internal {
      //1-7 May, 20%
      initBonusPeriod(1525132800, 1525737599, 20, 100);
      //8-14 May, 15%
      initBonusPeriod(1525737600, 1526342399, 15, 100);
      //15 -21 May, 10%
      initBonusPeriod(1526342400, 1526947199, 10, 100);
      //22 -28 May, 5%
      initBonusPeriod(1526947200, 1527551999, 5, 100);
  }

  function updateCurrentBonusPeriod() internal  {
    if (currentBonusPeriod.fromTimestamp <= block.timestamp
      && currentBonusPeriod.toTimestamp >= block.timestamp)
      return;

    currentBonusPeriod.fromTimestamp = INVALID_FROM_TIMESTAMP;

    for(uint i = 0; i < bonusPeriods.length; i++)
      if (bonusPeriods[i].fromTimestamp <= block.timestamp && bonusPeriods[i].toTimestamp >= block.timestamp) {
        currentBonusPeriod = bonusPeriods[i];
        return;
      }
  }
}
