// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {Test} from "forge-std/Test.sol";
import {LibString} from "solady/utils/LibString.sol";
import {UUIDLib} from "../src/utils/UUIDLib.sol";

contract UUIDLibInstance {
    function checkChar(bytes1 c, uint256 i) public view {
        UUIDLib.checkChar(c, i);
    }
}

/// @author philogy <https://github.com/philogy>
contract UUIDLibTest is Test {
    UUIDLibInstance lib;

    function setUp() public {
        lib = new UUIDLibInstance();
    }

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

    function testIsHexChar() public {
        for (uint256 i; i < 256; i++) {
            bytes1 char = bytes1(uint8(i));
            if (char == "0") {
                lib.checkChar(char, 0);
            } else if (char == "1") {
                lib.checkChar(char, 0);
            } else if (char == "2") {
                lib.checkChar(char, 0);
            } else if (char == "3") {
                lib.checkChar(char, 0);
            } else if (char == "4") {
                lib.checkChar(char, 0);
            } else if (char == "5") {
                lib.checkChar(char, 0);
            } else if (char == "6") {
                lib.checkChar(char, 0);
            } else if (char == "7") {
                lib.checkChar(char, 0);
            } else if (char == "8") {
                lib.checkChar(char, 0);
            } else if (char == "9") {
                lib.checkChar(char, 0);
            } else if (char == "a") {
                lib.checkChar(char, 0);
            } else if (char == "b") {
                lib.checkChar(char, 0);
            } else if (char == "c") {
                lib.checkChar(char, 0);
            } else if (char == "d") {
                lib.checkChar(char, 0);
            } else if (char == "e") {
                lib.checkChar(char, 0);
            } else if (char == "f") {
                lib.checkChar(char, 0);
            } else if (char == "A") {
                vm.expectRevert(abi.encodeWithSelector(UUIDLib.InvalidUUIDCharUpper.selector, 0, char));
                lib.checkChar(char, 0);
            } else if (char == "B") {
                vm.expectRevert(abi.encodeWithSelector(UUIDLib.InvalidUUIDCharUpper.selector, 0, char));
                lib.checkChar(char, 0);
            } else if (char == "C") {
                vm.expectRevert(abi.encodeWithSelector(UUIDLib.InvalidUUIDCharUpper.selector, 0, char));
                lib.checkChar(char, 0);
            } else if (char == "D") {
                vm.expectRevert(abi.encodeWithSelector(UUIDLib.InvalidUUIDCharUpper.selector, 0, char));
                lib.checkChar(char, 0);
            } else if (char == "E") {
                vm.expectRevert(abi.encodeWithSelector(UUIDLib.InvalidUUIDCharUpper.selector, 0, char));
                lib.checkChar(char, 0);
            } else if (char == "F") {
                vm.expectRevert(abi.encodeWithSelector(UUIDLib.InvalidUUIDCharUpper.selector, 0, char));
                lib.checkChar(char, 0);
            } else {
                vm.expectRevert(abi.encodeWithSelector(UUIDLib.InvalidUUIDCharOther.selector, 0, char));
                lib.checkChar(char, 0);
            }
        }
    }
}
