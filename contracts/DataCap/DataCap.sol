// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "../interface/IDataCap.sol";
import "@zondax/filecoin-solidity/contracts/v0.8/DataCapAPI.sol";
import "@openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract DataCap is IDataCap, ERC165 {
    struct MintParams {
        /// A non-negative amount to burn
        BigInt amount;
    }

    struct MintReturn {
        /// New balance in the account after the successful burn
        BigInt balance;
    }

    function name() external returns (string memory) {
        return DataCapAPI.name();
    }

    function symbol() external returns (string memory) {
        return DataCapAPI.symbol();
    }

    function totalSupply() external returns (BigInt memory) {
        DataCapAPI.totalSupply();
    }

    function balance(bytes calldata addr) external returns (BigInt memory) {
        DataCapAPI.balance(addr);
    }

    //!FIXME: mint not implemented
    function mint(MintParams memory params) internal returns (MintReturn memory) {
        bytes memory raw_request = params.serializeMintParams();

        bytes memory raw_response = Actor.call(
            DataCapTypes.MintMethodNum,
            DataCapTypes.ActorID,
            raw_request,
            Misc.CBOR_CODEC,
            msg.value,
            false
        );

        bytes memory result = Actor.readRespData(raw_response);

        return result.deserializeMintReturn();
    }

    function allowance(DataCapTypes.GetAllowanceParams calldata params)
        external
        returns (BigInt memory)
    {
        return DataCapAPI.allowance(params);
    }

    function transfer(DataCapTypes.TransferParams calldata params)
        external
        returns (DataCapTypes.TransferReturn memory)
    {
        return DataCapAPI.transfer(params);
    }

    function transferFrom(DataCapTypes.TransferFromParams calldata params)
        external
        returns (DataCapTypes.TransferFromReturn memory)
    {
        return DataCapAPI.transferFrom(params);
    }

    function increaseAllowance(DataCapTypes.IncreaseAllowanceParams calldata params)
        external
        returns (BigInt memory)
    {
        return DataCapAPI.increaseAllowance(params);
    }

    function decreaseAllowance(DataCapTypes.DecreaseAllowanceParams calldata params)
        external
        returns (BigInt memory)
    {
        return DataCapAPI.decreaseAllowance(params);
    }

    function revokeAllowance(DataCapTypes.RevokeAllowanceParams calldata params)
        external
        returns (BigInt memory)
    {
        return DataCapAPI.revokeAllowance(params);
    }

    function burn(DataCapTypes.BurnParams calldata params)
        external
        returns (DataCapTypes.BurnReturn memory)
    {
        return DataCapAPI.burn(params);
    }

    function burnFrom(DataCapTypes.BurnFromParams calldata params)
        external
        returns (DataCapTypes.BurnFromReturn memory)
    {
        return DataCapAPI.burnFrom(params);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IDataCap).interfaceId || super.supportsInterface(interfaceId);
    }
}
