// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.15;

/// @author philogy <https://github.com/philogy>
interface ITriggerable {
    function executeEmergencyTrigger() external;
}
