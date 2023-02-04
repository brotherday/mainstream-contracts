// SPDX-License-Identifier: APGL-3.0
pragma solidity ^0.8.0;
import {DataCap} from "./DataCap/DataCap.sol";

contract Presentation is DataCap {
    bytes public pieceCid;
    address public owner;
    bytes public topic;
    string public metadata;
    uint256 public ranking;
    uint256 public length;

    mapping(address => uint16) public votes;

    constructor(
        bytes memory _pieceCid,
        address _owner,
        string memory _metadata,
        uint256 _ranking
    ) {
        pieceCid = _pieceCid;
        owner = _owner;
        metadata = _metadata;
        ranking = _ranking;
    }

    function updateCID(bytes calldata _pieceCID) public {
        pieceCid = _pieceCID;
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

    function getVote(address _voter) public returns (uint16) {
        return votes[_voter];
    }

    function tokenURI() public returns (string memory) {
        return metadata;
    }
}
