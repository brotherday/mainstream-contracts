// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {Presentation} from "./Presentation.sol";
import {DealRewarder} from "./filecoin-api-examples/DealRewarder.sol";
import {FilecoinMarketConsumer} from "./filecoin-api-examples/FilecoinMarketConsumer.sol";

contract Library {
    address public owner;
    address[] public presentation;
    mapping(address => mapping(uint256 => address)) public presentationsByAccount;

    constructor(address _owner) {
        owner = _owner;
    }

    function add(
        bytes memory pieceCid,
        uint64 dealId,
        uint64 size,
        string memory metadata
    ) public {
        Presentation p = new Presentation(pieceCid, owner, metadata, 0);
        uint256 currentEpoch = block.timestamp;

        FilecoinMarketConsumer consumer = new FilecoinMarketConsumer();

        DealRewarder reward = new DealRewarder();

        consumer.storeAll(dealId);
        reward.addCID(pieceCid, size);

        reward.claim_bounty(dealId);

        presentationsByAccount[msg.sender][currentEpoch] = address(p);
    }
}
