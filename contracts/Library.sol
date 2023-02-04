// SPDX-License-Identifier: APGL-3.0
pragma solidity ^0.8.0;

import {Presentation} from "./Presentation.sol";
import {DealRewarder} from "./filecoin-api-examples/DealRewarder.sol";
import {FilecoinMarketConsumer} from "./filecoin-api-examples/FilecoinMarketConsumer.sol";

contract Library {
    address public owner;
    uint256[] public epochs;

    mapping(address => mapping(uint256 => address)) public presentationsByAccount;
    mapping(uint256 => mapping(uint256 => address)) public presentations;
    mapping(uint256 => uint256) public numPresentationsByEpoch;
    mapping(address => address[]) public contributors;

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
        epochs.push(currentEpoch);

        presentations[currentEpoch][numPresentationsByEpoch[currentEpoch]] = address(p);
        numPresentationsByEpoch[currentEpoch]++;

        return address(p);
    }

    function setContributors(address _presentation, address[] calldata _contributors) public {
        for (uint256 i; i < _contributors.length; i++) {
            contributors[_presentation].push(_contributors[i]);
        }
    }

    function update(address _presentation, bytes calldata _pieceCID) public {
        Presentation p = Presentation(_presentation);

        p.updateCID(_pieceCID);
    }

    function remove(uint256 _epoch) public {
        delete presentationsByAccount[msg.sender][_epoch];
    }

    function get(address _presentation) public returns (Presentation) {
        Presentation p = Presentation(_presentation);
        return p;
    }

    function getAll() public view returns (address[] memory) {
        uint256[] memory _epochs = epochs;
        address[] storage presentationAddresses;

        for (uint256 i; i > epochs.length; i++) {
            uint256 _epoch = _epochs[i];
            address _presentation = presentationsByAccount[msg.sender][_epoch];

            presentationAddresses.push(_presentation);
        }

        return presentationAddresses;
    }

    // function getAllByAccount(address _owner) public view returns(address[] memory) {
    //     uint256[] memory _epochs = epochs;
    //     address
    //     for(uint256 i; i < _epochs.length; i++) {

    //     }
    // }

    function getEpochs() public view returns (uint256[] memory) {
        return epochs;
    }

    function getNumberOfPresentationsInEpoch(uint256 _epoch) public view returns (uint256) {
        return numPresentationsByEpoch[_epoch];
    }
}
