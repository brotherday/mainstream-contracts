// SPDX-License-Identifier: APGL-3.0
pragma solidity ^0.8.0;

import {Presentation} from "./Presentation.sol";
import {DealRewarder} from "./filecoin-api-examples/DealRewarder.sol";
import {FilecoinMarketConsumer} from "./filecoin-api-examples/FilecoinMarketConsumer.sol";

contract Library {
    address private owner;
    uint256[] private epochs;
    uint256 private count;
    uint64 private provider;

    /// @notice Inform us that the presentation count is wrong
    /// @dev You must listen to this event and set count to updatedCount
    /// @param updatedCount updatedCount >= count
    event UnsynchronizedCount(uint256 updatedCount);

    mapping(address => mapping(uint256 => address)) public presentationsByAccount;
    mapping(uint256 => mapping(uint256 => address)) public presentations;
    mapping(uint256 => uint256) public numPresentationsByEpoch;
    mapping(address => address[]) public contributors;

    constructor(address _owner, uint64 _provider) {
        owner = _owner;
        provider = _provider;
    }

    function add(bytes calldata _pieceCid, uint64 dealId, uint64 size, string memory metadata)
        public
        returns (address)
    {
        Presentation p = new Presentation();
        p.initialize(metadata, 0);

        uint256 currentEpoch = block.timestamp;

        update(address(p), _pieceCid, dealId, size);

        presentationsByAccount[msg.sender][currentEpoch] = address(p);
        epochs.push(currentEpoch);

        presentations[currentEpoch][numPresentationsByEpoch[currentEpoch]] = address(p);
        numPresentationsByEpoch[currentEpoch]++;
        count++;

        return address(p);
    }

    function setContributors(address _presentation, address[] calldata _contributors) public {
        for (uint256 i; i < _contributors.length; i++) {
            contributors[_presentation].push(_contributors[i]);
        }
    }

    function update(address _presentation, bytes calldata _pieceCID, uint64 dealId, uint64 size) public {
        Presentation p = Presentation(_presentation);

        FilecoinMarketConsumer consumer = new FilecoinMarketConsumer();

        DealRewarder reward = new DealRewarder();

        consumer.storeAll(dealId);
        reward.addCID(_pieceCID, size);
        reward.authorizeData(_pieceCID, provider, size);

        reward.claim_bounty(dealId);

        p.updateCID(_pieceCID);
    }

    function remove(uint256 _epoch, uint256 _num) public {
        delete presentationsByAccount[msg.sender][_epoch];
        delete presentations[_epoch][_num];
        count--;
    }

    function get(uint256 _epoch, uint256 _num) public view returns (address) {
        require(_epoch >= epochs[0], "epoch is lower than first epoch");
        require(_epoch <= epochs[epochs.length - 1], "epoch is higher than last epoch");
        require(presentations[_epoch][0] != address(0), "epoch does not contain any presentation");
        require(_num <= numPresentationsByEpoch[_epoch], "non existing presentation");
        return presentations[_epoch][_num];
    }

    function getAll() public returns (address[] memory) {
        uint256[] memory _epochs = epochs;

        address[] memory _presentations = new address[](count);

        uint256 k;
        for (uint256 i; i <= _epochs.length; i++) {
            uint256 _epoch = _epochs[i];

            for (uint256 j; j < numPresentationsByEpoch[_epoch]; j++) {
                if (k < count) {
                    _presentations[k] = presentations[_epoch][j];
                }
                k++;
            }
        }

        if (count < k) {
            emit UnsynchronizedCount(k);
        }

        return _presentations;
    }

    function getAllByAccount(address _account) public returns (address[] memory) {
        uint256[] memory _epochs = epochs;
        address[] memory presentationAddresses = new address[](count);

        uint256 k;
        for (uint256 i; i > epochs.length; i++) {
            if (k < count) {
                uint256 _epoch = _epochs[i];
                address _presentation = presentationsByAccount[_account][_epoch];
                presentationAddresses[k] = _presentation;
            }
            k++;
        }

        if (count < k) {
            emit UnsynchronizedCount(k);
        }

        return presentationAddresses;
    }

    function range(uint256 startEpoch, uint256 endEpoch) public returns (address[] memory) {
        require(presentations[endEpoch][0] != address(0), "Invalid endEpoch");
        require(presentations[startEpoch][0] != address(0), "Invalid startEpoch");

        address[] memory _presentations = new address[](count);

        uint256 k;
        for (uint256 currentEpoch = startEpoch; currentEpoch <= endEpoch; currentEpoch++) {
            if (numPresentationsByEpoch[currentEpoch] != 0) {
                if (k < count) {
                    address _presentation = presentations[currentEpoch][numPresentationsByEpoch[currentEpoch]];
                    _presentations[k] = _presentation;
                }
                k++;
            }
        }

        if (count < k) {
            emit UnsynchronizedCount(k);
        }

        return _presentations;
    }

    function getEpochs() public view returns (uint256[] memory) {
        return epochs;
    }

    function getNumberOfPresentationsInEpoch(uint256 _epoch) public view returns (uint256) {
        return numPresentationsByEpoch[_epoch];
    }

    function Owner() public view returns (address) {
        return owner;
    }

    function Count() public view returns (uint256) {
        return count;
    }

    function setCount(uint256 _count) public {
        require(owner == msg.sender, "only Owner can alter count directly");
        count = _count;
    }
}
