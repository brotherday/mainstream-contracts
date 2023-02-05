// SPDX-License-Identifier: APGL-3.0
pragma solidity ^0.8.0;

import {File} from "./File/File.sol";

contract Presentation is File {
    bytes private pieceCid;
    string private metadata;
    uint256 private ranking;
    uint256 private length;

    uint256 public constant VOTE_MIN = 1;
    uint256 public constant VOTE_MAX = 10;

    mapping(address => uint8) public votes;

    function initialize(string memory _metadata, uint256 _ranking) public initializer {
        metadata = _metadata;
        ranking = _ranking;
    }

    function updateCID(bytes calldata _pieceCID) external {
        require(owner() == msg.sender);
        pieceCid = _pieceCID;
    }

    function updateRanking(uint8 grade) public {
        require(owner() == msg.sender);
        require(votes[msg.sender] != grade);
        require(grade >= VOTE_MIN, "grade too low");
        require(grade <= VOTE_MAX, "grade too high");

        uint256 _length = length;

        if (votes[msg.sender] == 0) {
            length++;
        } else {
            ranking -= votes[msg.sender] * 100;
        }

        ranking = (ranking * _length + grade * 100) / length;
        votes[msg.sender] = grade;
    }

    function getVote(address _voter) public view returns (uint8) {
        return votes[_voter];
    }

    function tokenURI() public view returns (string memory) {
        return metadata;
    }
}
