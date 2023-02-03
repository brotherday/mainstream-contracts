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
        if (votes[msg.sender] == grade) {
            return;
        }

        require(grade >= 1, "grade too low");
        require(grade <= 10, "grade too high");

        if (votes[msg.sender] == 0) {
            ranking = (ranking * length + grade * 100) / (length + 1);
            length++;
        } else {
            ranking -= votes[msg.sender] * 100;
            ranking = (ranking * length + grade * 100) / length;
        }
        votes[msg.sender] = grade;
    }
}
