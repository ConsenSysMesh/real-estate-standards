pragma solidity 0.4.20;


/// @title Metadata Registry - A repository storing metadata issued
///        from any Ethereum account to any spatial unit.
contract MetadataRegistry {

    struct Link {
        string multiaddr; // See https://github.com/multiformats/multiaddr.
        address owner;
        // bool permissioned;
        // bytes32 resultHash;
    }

    mapping(address => mapping(bytes32 => Link)) public registry;
    mapping(address => bytes32[]) public subjectKeys;
    mapping(address => mapping(bytes32 => uint)) public subjectKeysIndex;

    event LinkSet(
        address indexed issuer,
        address indexed subject,
        bytes32 indexed key,
        Link value,
        uint updatedAt);

    event LinkRemoved(
        address indexed issuer,
        address indexed subject,
        bytes32 indexed key,
        uint removedAt);

    /// @dev Create or update a link
    /// @param subject The address for the spatual unit
    /// @param key The key used to identify the link
    /// @param multiaddr The multiaddr associated with the link
    function setLink(address subject, bytes32 key, string multiaddr) public {
        require(registry[subject][key].length == 0);
        Link newLink = Link(multiaddr, msg.sender);
        registry[subject][key] = newLink;

        uint olen = subjectKeys[subject].length;
        subjectKeys[subject].length++;
        subjectKeys[subject][olen] = key;
        subjectKeysIndex[subject][key] = olen;

        LinkSet(msg.sender, subject, key, newLink, now);
    }

    /// @dev Allows to retrieve links from other contracts as well as other off-chain interfaces
    /// @param subject The address to which the link was issued to
    /// @param key The key used to identify the link
    function getLink(address subject, bytes32 key) public constant returns(
        string multiaddr,
        address owner
    ) {
        multiaddr = registry[subject][key].multiaddr;
        owner = registry[subject][key].owner;
    }

    /// @dev Allows to remove a link from the registry.
    ///      This can only be done by the issuer or the subject of the claim.
    /// @param subject The address to which the link was issued to
    /// @param key The key used to identify the link
    function removeLink(address subject, bytes32 key) public {
        require(registry[subject][key] != 0);
        require(msg.sender == registry[subject][key].owner || msg.sender == subject);
        delete registry[subject][key];

        unit keyIndex = subjectKeysIndex[subject][key];
        delete subjectKeys[subject][keyIndex];

        for (uint i = keyIndex; i<subjectKeys[subject].length-1; i++){
            subjectKeys[subject][i] = subjectKeys[subject][i+1];
        }
        delete subjectKeys[subject][subjectKeys[subject].length-1];
        subjectKeys[subject].length--;

        delete subjectKeysIndex[subject][key];

        LinkRemoved(msg.sender, subject, key, now);
    }

}