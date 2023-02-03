// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
import {IDataCap} from "./interface/IDataCap.sol";

contract Presentation {
    IDataCap DataCap;

    bytes public pieceCid;
    address public owner;
    bytes public topic;
    string public description;
    uint256 public ranking;
    uint256 public length;

    mapping(address => uint16) public votes;

    constructor(
        bytes memory _pieceCid,
        address _owner,
        bytes memory _topic,
        string memory _description,
        uint256 _ranking,
        address _dataCap
    ) {
        pieceCid = _pieceCid;
        owner = _owner;
        topic = _topic;
        description = _description;
        ranking = _ranking;
        DataCap = IDataCap(_dataCap);
    }

    function updateRanking(uint16 grade) public {
        return;
    }
}
