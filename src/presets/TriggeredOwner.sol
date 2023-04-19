// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Owned} from "solmate/auth/Owned.sol";
import {Multicallable} from "solady/utils/Multicallable.sol";
import {Triggerable} from "../Triggerable.sol";

/**
 * @author philogy <https://github.com/philogy>
 * @dev A standard intermediate contract that sits in-between an ownable contract and its owner so
 * that specific methods can be triggered. Owner of this contract can call any contract from this
 * contract. Requires the `_onTrigger` internal method to be implemented.
 */
abstract contract TriggeredOwner is Owned, Multicallable, Triggerable {
    constructor(address initialOwner, bytes memory deregInitUUID) Owned(initialOwner) Triggerable(deregInitUUID) {}

    receive() external payable {}

    function forwardCall(address to, bytes calldata cd, uint256 value, bool requireSuccess)
        external
        payable
        onlyOwner
        returns (bytes memory retData)
    {
        bool success;
        (success, retData) = to.call{value: value}(cd);
        if (!success && requireSuccess) {
            assembly {
                revert(add(0x20, retData), mload(retData))
            }
        }
    }
}
