// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

/// @author philogy <https://github.com/philogy>
interface ITriggerable {
    /**
     * @dev Unpack stored UUID and return.
     * @return The contract's set UUID in the expected format including dashes.
     */
    function DEREG_OWNER_UUID() external view returns (bytes memory);

    function executeTrigger() external;
}
