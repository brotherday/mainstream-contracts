// SPDX-License-Identifier: APGL-3.0
pragma solidity ^0.8.0;
import {DataCap} from "./DataCap/DataCap.sol";

contract Presentation is DataCap {
    bytes private pieceCid;
    address private owner;
    string private metadata;
    uint256 private ranking;
    uint256 private length;

    uint256 public constant VOTE_MIN = 1;
    uint256 public constant VOTE_MAX = 10;

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

    function updateCID(bytes calldata _pieceCID) external {
        pieceCid = _pieceCID;
    }

    function updateRanking(uint16 grade) public {
        if (votes[msg.sender] == grade) {
            return;
        }

        require(grade >= VOTE_MIN, "grade too low");
        require(grade <= VOTE_MAX, "grade too high");

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
