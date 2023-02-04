// SPDX-License-Identifier: APGL-3.0
pragma solidity ^0.8.0;

import {Presentation} from "./Presentation.sol";
import {DealRewarder} from "./filecoin-api-examples/DealRewarder.sol";
import {FilecoinMarketConsumer} from "./filecoin-api-examples/FilecoinMarketConsumer.sol";

contract Library {
    address public owner;
    address[] public presentation;
    mapping(address => mapping(uint256 => address)) public presentationsByAccount;
    uint256[] epoch;

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

        return address(p);
    }

    function get(address _presentation) public {
        return;
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
        Presentation updateP = Presentation(_presentation);

        updateP.pieceCid = _pieceCID;
    }

    function remove(address _presentation) public {
        return;
    }
}
