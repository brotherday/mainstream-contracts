// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@zondax/filecoin-solidity/contracts/v0.8/types/DataCapTypes.sol";
import {IDataCap} from "./interface/IDataCap.sol";

contract Presentation {
    IDataCap DataCap;

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
        uint16 _ranking,
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