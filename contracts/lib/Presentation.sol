// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {DataCapAPI} from "@zondax/filecoin-solidity/contracts/v0.8/DataCapAPI.sol";
import 

contract Presentation {
    using DataCapAPI for *;

    bytes public pieceCid;
    address public owner;
    bytes public topic;
    string public description;
    uint16 public ranking;
    uint256 public length;

    mapping(address => uint16) public votes;

    constructor(
        bytes memory _pieceCid,
        address _owner,
        bytes memory _topic,
        string memory _description,
        uint16 _ranking
    ) {
        pieceCid = _pieceCid;
        owner = _owner;
        topic = _topic;
        description = _description;
        ranking = _ranking;
    }

    function updateRanking(uint16 grade) public {}
}
