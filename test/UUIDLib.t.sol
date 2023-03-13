// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {Test} from "forge-std/Test.sol";
import {LibString} from "solady/utils/LibString.sol";
import {UUIDLib} from "../src/utils/UUIDLib.sol";

/// @author philogy <https://github.com/philogy>
contract UUIDLibTest is Test {
    function testSimpleUUID() public {
        assertEq(UUIDLib.toCompact("4f2c4196-a82b-4b33-8f8d-ef477b8f3b41"), "4f2c4196a82b4b338f8def477b8f3b41");
    }

    function test_fuzzingToCompat(uint128 _uuidSeed) public {
        string memory part5 = LibString.toHexStringNoPrefix(_uuidSeed & 0xffffffffffff, 6);
        string memory part4 = LibString.toHexStringNoPrefix((_uuidSeed >>= 4 * 12) & 0xffff, 2);
        string memory part3 = LibString.toHexStringNoPrefix((_uuidSeed >>= 4 * 4) & 0xffff, 2);
        string memory part2 = LibString.toHexStringNoPrefix((_uuidSeed >>= 4 * 4) & 0xffff, 2);
        string memory part1 = LibString.toHexStringNoPrefix((_uuidSeed >>= 4 * 4) & 0xffffffff, 4);
        bytes memory uuid = abi.encodePacked(part1, "-", part2, "-", part3, "-", part4, "-", part5);
        assertEq(UUIDLib.toCompact(uuid), bytes32(abi.encodePacked(part1, part2, part3, part4, part5)));
    }

    function test_fuzzingFromCompact(uint128 _uuidSeed) public {
        string memory part5 = LibString.toHexStringNoPrefix(_uuidSeed & 0xffffffffffff, 6);
        string memory part4 = LibString.toHexStringNoPrefix((_uuidSeed >>= 4 * 12) & 0xffff, 2);
        string memory part3 = LibString.toHexStringNoPrefix((_uuidSeed >>= 4 * 4) & 0xffff, 2);
        string memory part2 = LibString.toHexStringNoPrefix((_uuidSeed >>= 4 * 4) & 0xffff, 2);
        string memory part1 = LibString.toHexStringNoPrefix((_uuidSeed >>= 4 * 4) & 0xffffffff, 4);
        bytes memory uuid = abi.encodePacked(part1, "-", part2, "-", part3, "-", part4, "-", part5);
        assertEq(UUIDLib.fromCompact(bytes32(abi.encodePacked(part1, part2, part3, part4, part5))), uuid);
    }
}
