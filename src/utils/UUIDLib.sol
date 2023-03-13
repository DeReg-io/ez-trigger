// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @author philogy <https://github.com/philogy>
library UUIDLib {
    error InvalidUUIDLength();
    error InvalidUUIDChar(uint256 i, bytes1 char);

    uint256 internal constant UUID_LENGTH = 36;
    uint256 internal constant UUID_DASH1 = 8;
    uint256 internal constant UUID_DASH2 = 13;
    uint256 internal constant UUID_DASH3 = 18;
    uint256 internal constant UUID_DASH4 = 23;

    uint256 internal constant UUID_MASK1 = 0xffffffffffffffff000000000000000000000000000000000000000000000000;
    uint256 internal constant UUID_MASK2 = 0x000000000000000000ffffffff00000000000000000000000000000000000000;
    uint256 internal constant UUID_MASK3 = 0x0000000000000000000000000000ffffffff0000000000000000000000000000;
    uint256 internal constant UUID_MASK4 = 0x00000000000000000000000000000000000000ffffffff000000000000000000;
    uint256 internal constant UUID_MASK5 = 0x0000000000000000000000000000000000000000ffffffffffffffffffffffff;

    // bytes32 internal constant HEX_CHAR_MAP = 0x5858585858583938373635343332313058585858585858585866656463626158;

    bytes16 internal constant HEX_CHARS = "0123456789abcdef";

    function toCompact(bytes memory _uuid) internal pure returns (bytes32 compactUUID) {
        if (_uuid.length != UUID_LENGTH) revert InvalidUUIDLength();

        for (uint256 i; i < UUID_LENGTH;) {
            if (i == UUID_DASH1 || i == UUID_DASH2 || i == UUID_DASH3 || i == UUID_DASH4) {
                if (_uuid[i] != "-") revert InvalidUUIDChar(i, _uuid[i]);
            } else {
                if (!isHexChar(_uuid[i])) {
                    revert InvalidUUIDChar(i, _uuid[i]);
                }
            }

            // forgefmt: disable-next-item
            unchecked { ++i; }
        }

        assembly {
            let word1 := mload(add(_uuid, 0x20))
            let word2 := mload(add(_uuid, 0x24))

            compactUUID :=
                or(
                    or(and(word1, UUID_MASK1), shl(0x08, and(word1, UUID_MASK2))),
                    or(or(shl(0x10, and(word1, UUID_MASK3)), shl(0x18, and(word1, UUID_MASK4))), and(word2, UUID_MASK5))
                )
        }
    }

    function fromCompact(bytes32 _compactUUID) internal pure returns (bytes memory uuid) {
        assembly {
            uuid := mload(0x40)
            mstore(uuid, UUID_LENGTH)
            let offset := add(uuid, 0x20)

            mstore(offset, _compactUUID)
            offset := add(offset, 8)
            mstore8(offset, 0x2d)
            offset := add(offset, 1)
            mstore(offset, shl(0x40, _compactUUID))
            offset := add(offset, 4)
            mstore8(offset, 0x2d)
            offset := add(offset, 1)
            mstore(offset, shl(0x60, _compactUUID))
            offset := add(offset, 4)
            mstore8(offset, 0x2d)
            offset := add(offset, 1)
            mstore(offset, shl(0x80, _compactUUID))
            offset := add(offset, 4)
            mstore8(offset, 0x2d)
            offset := add(offset, 1)
            mstore(offset, shl(0xa0, _compactUUID))

            mstore(0x40, add(uuid, 0x60))
        }
    }

    function isHexChar(bytes1 _char) internal pure returns (bool) {
        for (uint256 i; i < 16;) {
            if (_char == HEX_CHARS[i]) return true;

            // forgefmt: disable-next-item
            unchecked { ++i; }
        }
        return false;
    }
}
