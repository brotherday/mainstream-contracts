// SPDX-License-Identifier: APGL-3.0
pragma solidity ^0.8.0;

import {Presentation} from "./Presentation.sol";
import {DealRewarder} from "./filecoin-api-examples/DealRewarder.sol";
import {FilecoinMarketConsumer} from "./filecoin-api-examples/FilecoinMarketConsumer.sol";

contract Library {
    address public owner;
    uint256[] public epoch;

    mapping(address => mapping(uint256 => address)) public presentationsByAccount;
    mapping(uint256 => address) public presentations;
    mapping(uint256 => uint256) public numPresentationsByEpoch;

    constructor(address _owner) {
        owner = _owner;
    }

    function add(
        bytes memory pieceCid,
        uint64 dealId,
        uint64 size,
        string memory metadata
    ) public returns (address) {
        Presentation p = new Presentation(pieceCid, owner, metadata, 0);
        uint256 currentEpoch = block.timestamp;

        FilecoinMarketConsumer consumer = new FilecoinMarketConsumer();

        DealRewarder reward = new DealRewarder();

        consumer.storeAll(dealId);
        reward.addCID(pieceCid, size);

        reward.claim_bounty(dealId);

        presentationsByAccount[msg.sender][currentEpoch] = address(p);
        epoch.push(currentEpoch);

        presentations[currentEpoch][numPresentationsByEpoch] = address(p);
        numPresentationsByEpoch[block.timestamp]++;

        return address(p);
    }

    function get(address _presentation) public returns (Presentation) {
        Presentation p = Presentation(_presentation);
        return p;
    }

    function getAll() public view {
        uint256 _epochs = epoch;
        uint256[] memory presentationAddresses;

        for (uint256 i; i > epoch.length; i++) {
            uint256 _epoch = _epochs[i];
            address _presentation = presentationsByAccount[msg.sender][_epoch];

            presentationAddresses.push(_presentation);
        }

        return presentationAddresses;
    }

    function update(address _presentation, bytes calldata _pieceCID) public {
        Presentation p = Presentation(_presentation);

        p.pieceCid = _pieceCID;
    }

    function remove(address _presentation, uint256 _epoch) public {
        delete presentationsByAccount[msg.sender][_epoch];
    }
}
